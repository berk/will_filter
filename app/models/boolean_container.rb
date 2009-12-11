class BooleanContainer < ModelFilterContainer

  def self.operators
    [:is]
  end

  def selected?
    value=="1"
  end

  def selected_text(val)
    return "checked" if value==val
  end

  def render_html(index)
    html = "<span>"
    html << "<input type='radio' #{html_mark_dirty} #{html_input_name(index, 0)} #{html_input_value('1')} #{selected_text("1")}> True"
    html << "&nbsp;&nbsp;"
    html << "<input type='radio' #{html_mark_dirty} #{html_input_name(index, 0)} #{html_input_value('0')} #{selected_text("0")}> False"
    html << "</span>"
    html
  end

  def sql_condition
    return [" #{condition_key} = ? ", (selected? ? true : false)] if operator_key == :is
  end

  def fql_condition
    return [" #{condition_key} = ? ", (selected? ? true : false).to_s] if operator_key == :is
  end

end
