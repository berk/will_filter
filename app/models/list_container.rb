class ListContainer < ModelFilterContainer

  def self.operators
    [:is, :is_not, :contains, :does_not_contain]
  end

  def render_html(index)
    html = "<select style='width:99%' #{html_input_name(index, 0)} #{html_mark_dirty}>"
    filter.value_options_for(condition_key).each do |item|
      if item.is_a?(Array)
        opt_name = item.first.to_s
        opt_value = item.last.to_s
      else
        opt_name = item.to_s
        opt_value = item.to_s
      end

      next if opt_name.strip == ""
      
      selected = ""
      selected = "selected" if opt_value == value

      opt_html = "<option #{selected} value=\"#{ERB::Util.html_escape(opt_value)}\">"
      opt_html << ERB::Util.html_escape(opt_name)
      opt_html << "</option>"

      html << opt_html
    end
    html << "</select>"
    html
  end

  def sql_condition
    return [" #{condition_key} = ? ", value] if operator_key == :is
    return [" #{condition_key} <> ? ", value] if operator_key == :is_not
    return [" #{condition_key} like ? ", "%#{value}%"] if operator_key == :contains
    return [" #{condition_key} not like ? ", "%#{value}%"] if operator_key == :does_not_cotain
  end

  def fql_condition
    return [" lower(#{condition_key}) = ? ", value.downcase] if operator_key == :is
    return [" lower(#{condition_key}) != ? ", value.downcase] if operator_key == :is_not
    return [" strpos(lower(#{condition_key}), ?) != '-1' ", value.downcase] if operator_key == :contains
    return [" strpos(lower(#{condition_key}), ?) = '-1' ", value.downcase] if operator_key == :does_not_cotain
  end

end
