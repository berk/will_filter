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

class Wf::BooleanContainer < Wf::FilterContainer

  def self.operators
    [:is]
  end

  def selected?
    value=="1"
  end

  def selected_text(val)
    return "checked" if value==val
  end

  def render_html(index)
    html = "<span>"
    html << "<input type='radio' #{html_input_attributes(index, 0, '1')} #{selected_text("1")}> True"
    html << "&nbsp;&nbsp;"
    html << "<input type='radio' #{html_input_attributes(index, 0, '0')} #{selected_text("0")}> False"
    html << "</span>"
    html
  end

  def sql_condition
    return [" #{condition.full_key} = ? ", (selected? ? true : false)] if operator == :is
  end
  
end
