class NumericBooleanContainer < BooleanContainer

  def sql_condition
    return [" #{condition_key} = ? ", (selected? ? 1 : 0)] if operator_key == :is
  end

  def fql_condition
    return [" #{condition_key} = ? ", (selected? ? 1 : 0).to_s] if operator_key == :is
  end

end
