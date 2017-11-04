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

module WillFilter
  class FilterContainer
    attr_accessor :filter, :condition, :operator, :values, :index
  
    def initialize(filter, condition, operator, values)
      @filter         = filter
      @condition      = condition
      @operator       = operator
      @values         = values
    end
  
    def value
      values.first
    end
  
    def date(dt = value)
      return nil unless dt
      Time.parse(dt).to_date
    rescue 
      nil
    end

    def time(tm = value)
      return nil unless tm
      Time.parse(tm)
    rescue 
      nil
    end

    def sanitized_value(index = 0)
      return '' if index >= values.size 
      return '' if values[index].blank?
      values[index].to_s.gsub("'", "&#39;")
    end
  
    # used by the list based containers
    def options
      []
    end
  
    def validate
      return "Value must be provided" if value.blank?
    end
  
    def reset_values
      @values = []
    end
    
    def template_name
      self.class.name.underscore.split('/').last
    end
    
    def serialize_to_params(params, index)
      values.each_with_index do |v, v_index|
        params["wf_v#{index}_#{v_index}"] = v
      end
    end

    def is_floating_point?(s)
      s.to_s.match(/\A[-+]?[0-9]*\.?[0-9]+\Z/) == nil ? false : true
    end

    def is_numeric?(s)
      s.to_s.match(/\A[-+]?[0-9]*\Z/) == nil ? false : true
    end
  
  end
end