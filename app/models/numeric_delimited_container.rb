class NumericDelimitedContainer < ModelFilterContainer

  NUMERIC_DELIMITER = ","

  def self.operators
    [:is_in]
  end

  def validate
    return "Values must be provided. Separate values with '#{NUMERIC_DELIMITER}'" if value.blank?
  end

  def split_values
    vals = []
    value.split(NUMERIC_DELIMITER).each do |val|
      vals << val.strip.to_i
    end
    vals
  end

  def sql_condition
    return [" #{condition_key} in (?) ", split_values] if operator_key == :is_in
  end

  def fql_condition
    return [" #{condition_key} in (?) ", split_values] if operator_key == :is_in
  end

end
