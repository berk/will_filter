class DateContainer < ModelFilterContainer

  def self.operators
    [:is, :is_not, :is_after, :is_before]
  end

  def render_html(index)
    html = "<table class='mf_container_values'><tr>"
    html << "<td width='99%'><input type='text' #{html_mark_dirty} style='width:99%' #{html_input_name(index, 0)} #{html_input_value}>"
    html << "</td><td width='1%'>"
    html << "<a href=\"#\" onclick=\"selectDate('#{html_input_id(index, 0)}', this); return false;\">"
    html << "<img align=\"top\" alt=\"select date\" border=\"0\" src=\"/images/mf_calendar.png\" />"
    html << "</a>"
    html << "</td>"
    html << "</tr></table>"
    html
  end

  def validate
    return "Value must be provided" if value.blank?
    return "Value must be a valid date (2008-01-01)" if date == nil
  end

  def date
    Date.parse(value)
  rescue ArgumentError
    nil
  end

  def sql_condition
    return [" #{condition_key} = ? ", date]  if operator_key == :is
    return [" #{condition_key} <> ? ", date] if operator_key == :is_not
    return [" #{condition_key} > ? ", date]  if operator_key == :is_after
    return [" #{condition_key} < ? ", date]  if operator_key == :is_before
  end

  def fql_condition
    return [" #{condition_key} = ? ",   date.to_time.to_i]  if operator_key == :is
    return [" #{condition_key} != ? ",  date.to_time.to_i]  if operator_key == :is_not
    return [" #{condition_key} > ? ",   date.to_time.to_i]  if operator_key == :is_after
    return [" #{condition_key} < ? ",   date.to_time.to_i]  if operator_key == :is_before
  end

end
