#--
# Copyright (c) 2010 Michael Berkovich, Geni Inc
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

module Wf::HelperMethods

  def will_filter(results)
    render(:partial => "/wf/filter/container", :locals => {:wf_filter => results.wf_filter})
  end

  def will_filter_scripts_tag
    render(:partial => "/wf/common/scripts")
  end
  
  def will_filter_table_tag(filter, fields = [])
    html = "<table cellspacing='1px' cellpadding='1px'>"
    html <<  "<tr>"
    filter.fields.each do |field|
      html << "<th>" << field.to_s << "</th>"
    end
    html <<  "</tr>"
    
    filter.results.each do |obj|
      html <<  "<tr>"
      filter.fields.each do |field|
        html << "<td>" << obj.send(field).to_s << "</td>"
      end
      html <<  "</tr>"
    end  
    html <<  "</table>"  
  end
  
end
