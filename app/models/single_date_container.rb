class SingleDateContainer < ModelFilterContainer

  def self.operators
    [:is_on]
  end

  def render_html(index)
    html = "<table class='mf_container_values'><tr>"
    html << "<td width='99%'><input type='text' #{html_mark_dirty} style='width:99%' #{html_input_name(index, 0)} #{html_input_value}>"
    html << "</td>"
    html << "<td width='1%'><a href=\"#\" onclick=\"selectDate('#{html_input_id(index, 0)}', this); return false;\">"
    html << "<img align=\"top\" alt=\"select date\" border=\"0\" src=\"/images/mf_calendar.png\" />"
    html << "</a>"
    html << "</td>"
    html << "</tr></table>"
    html
  end

  def html_input_value(val = value)
    return "value=''" if val.blank?
    val = Date.parse(val).to_s
    "value='#{val}'"
  rescue ArgumentError
    "value=''"
  end

  def validate
    return "Value must be provided" if value.blank?
  end

  def start_date_time
    Date.parse(value).to_time
  rescue ArgumentError
    nil
  end

  def end_date_time
    (start_date_time + 1.day)
  rescue ArgumentError
    nil
  end

  def sql_condition
    return [" #{condition_key} >= ? and  #{condition_key} < ? ", start_date_time, end_date_time]  if operator_key == :is_on
  end

  def fql_condition
    return [" #{condition_key} >= ? and  #{condition_key} < ? ", start_date_time.to_i, end_date_time.to_i]  if operator_key == :is_on
  end

end
