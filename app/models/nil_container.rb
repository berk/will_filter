class NilContainer < ModelFilterContainer

  def self.operators
    [:is_provided, :is_not_provided]
  end

  def render_html(index)
    ""
  end

  def validate
    # no validation is necessary
  end

  def sql_condition
    return [" #{condition_key} is not null "]  if operator_key == :is_provided
    return [" #{condition_key} is null "]      if operator_key == :is_not_provided
  end

  def fql_condition
    return [" strlen(#{condition_key}) > 0 "]  if operator_key == :is_provided
    return [" strlen(#{condition_key}) = 0 "]  if operator_key == :is_not_provided
  end

end
