class ModelFilterContainer

  attr_accessor :values, :condition_key, :filter, :operator_key

  def initialize(filter, condition_key, operator_key, values)
    @filter         = filter
    @condition_key  = condition_key
    @operator_key   = operator_key
    @values         = values
  end

  def value
    values.first
  end
  
  def render_html(index)
    html = "<input type='text' style='width:98%' #{html_mark_dirty} #{html_input_name(index, 0)} #{html_input_value}>"
    html
  end

  def validate
    return "Value must be provided" if value.blank?
  end

  def reset_values
    @values = []
  end

  def generate_time_options(size)
    html = ""
    0.upto(size) do |i|
      val = (i<10 ? "0" : "")
      val << i.to_s
      html << "<option>#{val}</option>"
    end
    html
  end

  def html_input_id(i, j)
    "#{ModelFilter::HTML[:value]}_#{i}_#{j}"
  end

  def html_input_name(i, j)
    "name='#{html_input_id(i, j)}' id='#{html_input_id(i, j)}'"
  end

  def html_input_value(val = value)
    return "value=''" if val.blank?
    return "value='#{val}'" unless val.is_a?(String)
    
    "value='#{val.gsub("'", "&#39;")}'"
  end
  
  def html_mark_dirty
    "onChange='fieldChanged(this)'"
  end
  
  def serialize_to_params(params, index)
    params["#{ModelFilter::HTML[:value]}_#{index}_0"] = value
  end

end
