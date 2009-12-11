class NumericContainer < ModelFilterContainer

  def self.operators
    [:is, :is_not, :is_less_than, :is_greater_than]
  end

  def numeric_value
    value.to_i
  end

  def validate
    return "Value must be provided" if value.blank?
    return "Value must be numeric" if numeric_value == 0
  end

  def sql_condition
    return [" #{condition_key} = ? ",   numeric_value]    if operator_key == :is
    return [" #{condition_key} <> ? ",  numeric_value]    if operator_key == :is_not
    return [" #{condition_key} < ? ",   numeric_value]    if operator_key == :is_less_than
    return [" #{condition_key} > ? ",   numeric_value]    if operator_key == :is_greater_than
  end

  def fql_condition
    return [" #{condition_key} = ? ",   numeric_value]    if operator_key == :is
    return [" #{condition_key} != ? ",  numeric_value]    if operator_key == :is_not
    return [" #{condition_key} < ? ",   numeric_value]    if operator_key == :is_less_than
    return [" #{condition_key} > ? ",   numeric_value]    if operator_key == :is_greater_than
  end

end
