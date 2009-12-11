class FiveRadiosContainer < ModelFilterContainer

  def self.operators
    [:is]
  end

  def selected_text(val)
    return "checked" if value==val
  end

  def render_html(index)
    html = "<span>"
    1.upto(5) do |i| 
      html << "<input type='radio' #{html_mark_dirty} #{html_input_name(index, i)} #{html_input_value(i.to_s)} #{selected_text(i.to_s)}> " << i.to_s
      html << "&nbsp;&nbsp;"
    end
    html << "</span>"
    html
  end

  def sql_condition
    return [" #{condition_key} = ? ", value] if operator_key == :is
  end

  def fql_condition
    return [" #{condition_key} = ? ", value] if operator_key == :is
  end

end
