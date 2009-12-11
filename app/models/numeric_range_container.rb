class NumericRangeContainer < ModelFilterContainer

  attr_accessor :start_value, :end_value

  def self.operators
    [:is_in_the_range]
  end

  def initialize(filter, criteria_key, operator, values)
    super(filter, criteria_key, operator, values)

    if values
      @start_value = values[0]
      @end_value = values[1] if values.size > 1
    end

  end

  def validate
    return "Start value must be provided" if start_value.blank?
    return "Start value must be numeric" if numeric_start_value == 0
    return "End value must be provided" if end_value.blank?
    return "End value must be numeric" if numeric_end_value == 0
  end

  def serialize_to_params(params, index)
    params["#{ModelFilter::HTML[:value]}_#{index}_0"] = start_value
    params["#{ModelFilter::HTML[:value]}_#{index}_1"] = end_value
  end

  def render_html(index)
    html = "<table width='98%'><tr>"
    html << "<td width='48%'><input type='text' #{html_mark_dirty} style='width:100%' #{html_input_name(index, 0)} #{html_input_value(@start_value)}></td>"
    html << "<td width='4%'>&nbsp;</td>"
    html << "<td width='48%'><input type='text' #{html_mark_dirty} style='width:100%' #{html_input_name(index, 1)} #{html_input_value(@end_value)}></td>"
    html << "</tr></table>"
    html
  end

  def numeric_start_value
    start_value.to_i
  end

  def numeric_end_value
    end_value.to_i
  end

  def sql_condition
    return [" (#{condition_key} >= ? and #{condition_key} <= ?) ", numeric_start_value, numeric_end_value] if operator_key == :is_in_the_range
  end
  
  def fql_condition
    sql_condition
  end
  
end
