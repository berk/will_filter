class TextContainer < ModelFilterContainer

  def self.operators
    [:is, :is_not, :contains, :does_not_contain, :starts_with, :ends_with]
  end

  def validate
    # always valid, even when it is empty
  end

  def sql_condition
    return [" #{condition_key} = ? ", value]                 if operator_key == :is
    return [" #{condition_key} <> ? ", value]                if operator_key == :is_not
    return [" #{condition_key} like ? ", "%#{value}%"]       if operator_key == :contains
    return [" #{condition_key} not like ? ", "%#{value}%"]   if operator_key == :does_not_contain
    return [" #{condition_key} like ? ", "#{value}%"]        if operator_key == :starts_with
    return [" #{condition_key} like ? ", "%#{value}"]        if operator_key == :ends_with
  end

  def fql_condition
    return [" lower(#{condition_key}) = ? ",  value.downcase]                       if operator_key == :is
    return [" lower(#{condition_key}) != ? ", value.downcase]                       if operator_key == :is_not
    return [" strpos(lower(#{condition_key}), ?) != '-1' ", value.downcase]         if operator_key == :contains
    return [" strpos(lower(#{condition_key}), ?) = '-1' ",  value.downcase]         if operator_key == :does_not_contain
    return [" strpos(lower(#{condition_key}), ?) = '0' ",   value.downcase]         if operator_key == :starts_with
    return [" strpos(lower(#{condition_key}), ?) = (strlen(#{condition_key}) - #{value.size}) ", value.downcase]        if operator_key == :ends_with
  end

end
