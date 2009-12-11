class FilterListContainer < ModelFilterContainer

  def self.operators
    [:is_filtered_by]
  end

  def validate
    return "Value must be provided" if value.blank?
  end

  def render_html(index)
    html = "<select style='width:99%' #{html_input_name(index, 0)} #{html_mark_dirty}>"
    if condition_key == :id
      model_class_name = filter.model_class_name
    else
      model_class_name = condition_key.to_s[0..-4].camelcase
    end
    identity_filters = ModelFilter.new(model_class_name, filter.identity).saved_filters(false)
    identity_filters.each do |filter|
      opt_name = filter[0]
      opt_value = filter[1]

      selected = ""
      selected = "selected" if opt_value == value

      opt_html = "<option #{selected} value=\"#{opt_value}\">"
      opt_html << opt_name
      opt_html << "</option>"

      html << opt_html
    end
    html << "</select>"
    html
  end

  def sql_condition
    return nil unless operator_key == :is_filtered_by
    
    sub_filter = ModelFilter.find_by_id(value)
    sub_conds = sub_filter.sql_conditions
    sub_sql = "SELECT id FROM #{sub_filter.table_name} WHERE #{sub_conds[0]}"
    sub_conds[0] = " #{condition_key} IN (#{sub_sql}) "
    sub_conds
  end

  def fql_condition
    sql_condition
  end

end
