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
    class NumericDelimited < WillFilter::FilterContainer
      NUMERIC_DELIMITER = "," unless defined?(NUMERIC_DELIMITER)

      def self.operators
        [:is_in]
      end

      def template_name
        'text'
      end

      def validate
        return "Values must be provided. Separate values with '#{NUMERIC_DELIMITER}'" if value.blank?
      end

      def split_values
        value.split(NUMERIC_DELIMITER).collect {|v| v.strip.to_i}
      end

      def sql_condition
        return [" #{condition.full_key} in (?) ", split_values] if operator == :is_in
      end
    end
  end
end