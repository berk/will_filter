#--
# Copyright (c) 2017 Michael Berkovich, theiceberk@gmail.com
#
#  __    __  ____  _      _          _____  ____  _     ______    ___  ____
# |  |__|  ||    || |    | |        |     ||    || |   |      |  /  _]|    \
# |  |  |  | |  | | |    | |        |   __| |  | | |   |      | /  [_ |  D  )
# |  |  |  | |  | | |___ | |___     |  |_   |  | | |___|_|  |_||    _]|    /
# |  `  '  | |  | |     ||     |    |   _]  |  | |     | |  |  |   [_ |    \
#  \      /  |  | |     ||     |    |  |    |  | |     | |  |  |     ||  .  \
#   \_/\_/  |____||_____||_____|    |__|   |____||_____| |__|  |_____||__|\_|
#
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'csv'

module WillFilter
  class ExporterController < ApplicationController
    
    def index
      @wf_filter = WillFilter::Filter.deserialize_from_params(params.permit!)
      render :layout => false
    end
  
    def export
      params[:page] = 1
      params[:wf_per_page] = 10000 # max export limit
  
      @wf_filter = WillFilter::Filter.deserialize_from_params(params.permit!)
      
      if @wf_filter.custom_format?
        send_data(@wf_filter.process_custom_format, :type => 'text', :charset => 'utf-8')
        return
      end
      
      unless @wf_filter.valid_format?
        render :text => "The export format is not supported (#{@wf_filter.format})"
        return     
      end
      
      if @wf_filter.format == :xml
        return send_xml_data(@wf_filter)
      end  
  
      if @wf_filter.format == :json
        return send_json_data(@wf_filter)
      end  
      
      if @wf_filter.format == :csv
        return send_csv_data(@wf_filter)
      end  
  
      render :layout => false
    end  
  
  private
    
    def results_from(wf_filter)
      results = []
      
      wf_filter.results.each do |obj|
        hash = {}
        wf_filter.fields.each do |field|
          hash[field] = obj.send(field).to_s 
        end  
        results << hash
      end
      
      results
    end
  
    def send_xml_data(wf_filter)
      send_data(results_from(wf_filter).to_xml, :type => 'text/xml', :charset => 'utf-8')
    end  
  
    def send_json_data(wf_filter)
      send_data(results_from(wf_filter).to_json, :type => 'text', :charset => 'utf-8')
    end  
    
    def send_csv_data(wf_filter)
      csv_string = CSV.generate do |csv|
        csv << wf_filter.fields
        wf_filter.results.each do |obj|
          row = []
          wf_filter.fields.each do |field|
            row << obj.send(field).to_s 
          end    
          csv << row
        end
      end
      
      send_data csv_string, :type => 'text/csv; charset=utf-8; header=present', :charset => 'utf-8', 
                            :disposition => "attachment; filename=results.csv"      
    end
  end
end