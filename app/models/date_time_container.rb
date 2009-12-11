class DateTimeContainer < ModelFilterContainer

  def self.operators
    [:is, :is_not, :is_after, :is_before]
  end

  def render_html(index)
    html = "<table class='mf_container_values'><tr>"
    html << "<td width='99%'><input type='text' #{html_mark_dirty} style='width:99%' #{html_input_name(index, 0)} #{html_input_value}>"
    html << "</td>"
    html << "<td width='1%'><a href=\"#\" onclick=\"selectDateTime('#{html_input_id(index, 0)}', this); return false;\">"
    html << "<img align=\"top\" alt=\"select date\" border=\"0\" src=\"/images/mf_calendar.png\" />"
    html << "</a>"
    html << "</td>"
    html << "</tr></table>"
    html
  end

  def validate
    return "Value must be provided" if value.blank?
    return "Value must be a valid date/time (2008-01-01 14:30:00)" if time == nil
  end

  def time
    Date.parse(value)
    Time.parse(value)
  rescue ArgumentError
    nil
  end

  def sql_condition
    return [" #{condition_key} = ? ",   time]     if operator_key == :is
    return [" #{condition_key} <> ? ",  time]     if operator_key == :is_not
    return [" #{condition_key} > ? ",   time]     if operator_key == :is_after
    return [" #{condition_key} < ? ",   time]     if operator_key == :is_before
  end

  def fql_condition
    return [" #{condition_key} = ? ",   time.to_i]    if operator_key == :is
    return [" #{condition_key} != ? ",  time.to_i]    if operator_key == :is_not
    return [" #{condition_key} > ? ",   time.to_i]    if operator_key == :is_after
    return [" #{condition_key} < ? ",   time.to_i]    if operator_key == :is_before
  end

end
