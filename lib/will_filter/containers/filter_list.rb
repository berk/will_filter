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
    class FilterList < WillFilter::FilterContainer
      def self.operators
        [:is_filtered_by]
      end
    
      def validate
        return "Value must be provided" if value.blank?
      end
    
      def template_name
        'list'
      end

      def linked_filter
        @linked_filter ||= begin
          if condition.key == :id
            model_class_name = filter.model_class_name
          else
            model_class_name = condition.key.to_s[0..-4].camelcase
          end
          WillFilter::Filter.new(model_class_name)
        end
      end
    
      def options
        linked_filter.saved_filters(false)
      end
    
      def sql_condition
        return nil unless operator == :is_filtered_by
        sub_filter = WillFilter::Filter.find_by_id(value) || linked_filter.user_filters.first
        return [''] unless sub_filter

        sub_conds = sub_filter.sql_conditions

        if sub_conds[0].blank?
          sub_conds[0] = " #{condition.full_key} IN (SELECT #{sub_filter.table_name}.id FROM #{sub_filter.table_name}) "
        else
          sub_conds[0] = " #{condition.full_key} IN (SELECT #{sub_filter.table_name}.id FROM #{sub_filter.table_name} WHERE #{sub_conds[0]}) "
        end  

        sub_conds
      end
    end
  end
end