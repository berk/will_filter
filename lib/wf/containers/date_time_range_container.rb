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

class Wf::DateTimeRangeContainer < Wf::FilterContainer

  attr_accessor :start_value, :end_value

  def self.operators
    [:is_in_the_range]
  end

  def initialize(filter, criteria_key, operator, values)
    super(filter, criteria_key, operator, values)

    @start_value = values[0]
    @end_value = values[1] if values.size > 1
  end

  def validate
    return "Start value must be provided" if start_value.blank?
    return "Start value must be a valid date/time (2008-01-01 14:30:00)" if start_time == nil
    return "End value must be provided" if end_value.blank?
    return "End value must be a valid date/time (2008-01-01 14:30:00)" if end_time == nil
  end

  def render_html(index)
    html = "<table class='wf_values_table' cellspacing='0px' cellpadding='0px'><tr>"
    html << "<td width='49%'><input type='text' style='width:99%' #{html_input_attributes(index, 0)}>"
    html << "</td><td width='1%'>"
    html << html_time_selector(index, 0)
    html << "</td>"
    html << "<td width='49%'><input type='text' style='width:99%' #{html_input_attributes(index, 1)}>"
    html << "</td><td width='1%'>"
    html << html_time_selector(index, 1)
    html << "</td>"
    html << "</tr></table>"
    html
  end

  def start_time
    Time.parse(start_value)
  rescue ArgumentError
    nil
  end

  def end_time
    Time.parse(end_value)
  rescue ArgumentError
    nil
  end

  def sql_condition
    return [" (#{condition.full_key} >= ? and #{condition.full_key} <= ?) ", start_time, end_time] if operator == :is_in_the_range
  end

end
