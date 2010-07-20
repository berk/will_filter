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

class Wf::FilterContainer

  attr_accessor :filter, :condition, :operator, :values

  def initialize(filter, condition, operator, values)
    @filter         = filter
    @condition      = condition
    @operator       = operator
    @values         = values
  end

  def value
    values.first
  end

  def validate
    return "Value must be provided" if value.blank?
  end

  def reset_values
    @values = []
  end

  def html_input_id(i, j = 0)
    "wf_v#{i}_#{j}"
  end
  
  def html_input_name(i, j = 0)
    html_input_id(i, j)
  end

  def html_input_name_and_id(i, j = 0)
    "name='#{html_input_name(i, j)}' id='#{html_input_id(i, j)}''"
  end

  def html_input_value(v = value)
    return "value=''" if v.blank?
    return "value='#{v.to_s}'" unless v.is_a?(String)
    
    "value='#{v.gsub("'", "&#39;")}'"
  end

  def html_mark_dirty
    "onChange='wfFilter.fieldChanged(this)'"
  end

  def html_input_attributes(i, j = 0, v = nil)
    if v.nil?
      "class='wf_input' name=#{html_input_name(i, j)} id=#{html_input_id(i, j)} #{html_mark_dirty} #{html_input_value(values[j])}"
    else
      "class='wf_input' name=#{html_input_name(i, j)} id=#{html_input_id(i, j)} #{html_mark_dirty} #{html_input_value(v)}"
    end
  end

  def html_date_selector(index, value_index = 0)  
    html = "<a href=\"#\" onclick=\"wfCalendar.selectDate('#{html_input_id(index, value_index)}', this); return false;\">"
    html << "<img align=\"top\" alt=\"select date\" border=\"0\" class=\"wf_calendar_trigger\" src=\"/wf/images/calendar.png\" />"
    html << "</a>"
  end 

  def html_time_selector(index, value_index = 0)  
    html = "<a href=\"#\" onclick=\"wfCalendar.selectDateTime('#{html_input_id(index, value_index)}', this); return false;\">"
    html << "<img align=\"top\" alt=\"select date\" border=\"0\" class=\"wf_calendar_trigger\" src=\"/wf/images/calendar.png\" />"
    html << "</a>"
  end 
  
  def render_html(index)
    html = "<table class='wf_values_table' cellspacing='0px' cellpadding='0px'><tr>"
    html << "<td width='99%'><input type='text' style='width:99%;' #{html_input_attributes(index)}>"
    html << "</td></tr></table>"
  end
  
  def serialize_to_params(params, index)
    values.each_with_index do |v, v_index|
      params[html_input_id(index, v_index)] = v
    end
  end

end
