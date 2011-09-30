class UserFilter < WillFilter::Filter

  def definition
    defs = super  
    defs[:sex][:is] = :list
    defs[:sex][:is_not] = :list
    defs
  end

  def value_options_for(criteria_key)
    if criteria_key == :sex
      return ["male", "female"]
    end

    return []
  end

  def default_filters
    [
      ["Male Only", "male_only"],
      ["Females With Last Name 'Adams'", "adams"],
      ["First Names Start With 'A'", "first_names_start_with_a"],
      ["Last Names Containing 'son'", "last_names_containing_son"],
      ["Susans Born Between 2000 and 2010", "susans"],
    ]
  end

  def default_filter_conditions(key)
    return [:sex, :is, "male"] if (key == "male_only")
    return [[:sex, :is, "female"],[:last_name, :is, "Adams"]] if (key == "adams")
    return [:first_name, :starts_with, "A"] if (key == "first_names_start_with_a")
    return [:last_name, :contains, "son"] if (key == "last_names_containing_son")
    if (key == "susans")
      return [[:first_name, :is, "Susan"], 
              [:birthday, :is_in_the_range, [Date.new(2000,1,1), Date.new(2010,1,1)]]]
    end
  end

  def order_clause
    if key == "first_names_start_with_a"
      @order = 'first_name'
      @order_type = 'asc'
    end

    if key == "last_names_containing_son"
      @order = 'last_name'
      @order_type = 'asc'
    end
    
    super
  end
  
  def default_filter_if_empty
    "male_only"
  end

end
