class DateRangeContainer < ModelFilterContainer

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
    return "Start value must be a valid date (2008-01-01)" if start_date == nil
    return "End value must be provided" if end_value.blank?
    return "End value must be a valid date (2008-01-01)" if end_date == nil
  end

  def render_html(index)
    html = "<table class='mf_container_values'><tr>"
    html << "<td width='49%'><input type='text' #{html_mark_dirty} style='width:99%' #{html_input_name(index, 0)} #{html_input_value(@start_value)}>"
    html << "</td>"
    html << "<td width='1%'><a href=\"#\" onclick=\"selectDate('#{html_input_id(index, 0)}', this); return false;\">"
    html << "<img alt=\"select date\" border=\"0\" src=\"/images/mf_calendar.png\" />"
    html << "</a>"
    html << "</td>"
    html << "<td width='49%'><input type='text' #{html_mark_dirty} style='width:99%' #{html_input_name(index, 1)} #{html_input_value(@end_value)}>"
    html << "</td>"
    html << "<td width='1%'><a href=\"#\" onclick=\"selectDate('#{html_input_id(index, 1)}', this); return false;\">"
    html << "<img alt=\"select date\" border=\"0\" src=\"/images/mf_calendar.png\" />"
    html << "</a>"
    html << "</td>"
    html << "</tr></table>"
    html  
  end

  def serialize_to_params(params, index)
    params["#{ModelFilter::HTML[:value]}_#{index}_0"] = start_value
    params["#{ModelFilter::HTML[:value]}_#{index}_1"] = end_value
  end

  def start_date
    Date.parse(start_value)
  rescue ArgumentError
    nil
  end

  def end_date
    Date.parse(end_value)
  rescue ArgumentError
    nil
  end

  def sql_condition
    return [" (#{condition_key} >= ? and #{condition_key} <= ?) ", start_date, end_date] if operator_key == :is_in_the_range
  end
  
  def fql_condition
    return [" (#{condition_key} >= ? and #{condition_key} <= ?) ", start_date.to_time.to_i, end_date.to_time.to_i] if operator_key == :is_in_the_range
  end
  
end
