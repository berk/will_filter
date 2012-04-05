#--
# Copyright (c) 2010-2012 Michael Berkovich
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

module WillFilter
  class FilterController < ApplicationController
    def index
      @filters = WillFilter::Filter.new(WillFilter::Filter).deserialize_from_params(params).results
    end
  
    def update_condition
      wf_filter = WillFilter::Filter.deserialize_from_params(params)
      condition = wf_filter.condition_at(params[:at_index].to_i)
      condition.container.reset_values
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => wf_filter})
    end
  
    def remove_condition
      wf_filter = WillFilter::Filter.deserialize_from_params(params)
      wf_filter.remove_condition_at(params[:at_index].to_i)
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => wf_filter})
    end
  
    def add_condition
      wf_filter = WillFilter::Filter.deserialize_from_params(params)
      index = params[:after_index].to_i
      if index == -1
        wf_filter.add_default_condition_at(wf_filter.size)
      else
        wf_filter.add_default_condition_at(params[:after_index].to_i + 1)
      end
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => wf_filter})
    end
  
    def remove_all_conditions
      wf_filter = WillFilter::Filter.deserialize_from_params(params)
      wf_filter.remove_all
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => wf_filter})
    end
  
    def load_filter
      wf_filter = WillFilter::Filter.deserialize_from_params(params)
      wf_filter = wf_filter.load_filter!(params[:wf_key])
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => wf_filter})
    end
  
    def save_filter
      raise WillFilter::FilterException.new("Saving functions are disabled") unless  WillFilter::Config.saving_enabled?

      params.delete(:wf_id)
      
      wf_filter = WillFilter::Filter.deserialize_from_params(params)
      wf_filter.validate!
      
      unless wf_filter.errors?
        wf_filter.save
      end
      
      wf_filter.key= wf_filter.id.to_s 
      
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => wf_filter})
    end
  
    def update_filter
      raise WillFilter::FilterException.new("Update functions are disabled") unless  WillFilter::Config.saving_enabled?

      wf_filter = WillFilter::Filter.find_by_id(params.delete(:wf_id))
      wf_filter.deserialize_from_params(params)
      wf_filter.validate!
      
      unless wf_filter.errors?
        wf_filter.save
      end
      
      wf_filter.key= wf_filter.id.to_s 
      
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => wf_filter})
    end
  
    def delete_filter
      raise WillFilter::FilterException.new("Delete functions are disabled") unless  WillFilter::Config.saving_enabled?

      wf_filter = WillFilter::Filter.find_by_id(params[:wf_id])
      wf_filter.destroy if wf_filter
  
      wf_filter = WillFilter::Filter.deserialize_from_params(params)
      wf_filter.id=nil
      wf_filter.key=nil
      wf_filter.remove_all
      
      render(:partial => '/will_filter/filter/conditions', :layout=>false, :locals => {:wf_filter => wf_filter})
    end
  end
end