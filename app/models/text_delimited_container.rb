class TextDelimitedContainer < ModelFilterContainer

  TEXT_DELIMITER = ","

  def self.operators
    [:is_in]
  end

  def validate
    return "Values must be provided. Separate values with '#{TEXT_DELIMITER}'" if value.blank?
  end

  def split_values
    value.split(TEXT_DELIMITER)
  end

  def sql_condition
    return [" #{condition_key} in (?) ", split_values] if operator_key == :is_in
  end

  def fql_condition
    sql_condition
  end

end
