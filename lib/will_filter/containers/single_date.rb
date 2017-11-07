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
  module Containers
    class SingleDate < WillFilter::FilterContainer
      def self.operators
        [:is_on, :is_not_on]
      end

      def template_name
        'date'
      end

      def validate
        return "Value must be provided" if value.blank?
        return "Value must be a valid date (2008-01-01)" if start_date_time == nil
      end

      def start_date_time
        @start_date_time ||= Time.parse(value)
      rescue ArgumentError
        nil
      end

      def end_date_time
        (start_date_time + 1.day)
      rescue ArgumentError
        nil
      end

      def sql_condition
        return [" #{condition.full_key} >= ? and #{condition.full_key} < ? ", time, time + 1.day] if operator == :is_on
        return [" #{condition.full_key} < ? and #{condition.full_key} >= ? ", time, time + 1.day] if operator == :is_not_on
      end
    end
  end
end