class EventFilter < WillFilter::Filter

  def model_class
    Event
  end

  def definition
    defs = super  
    defs[:"user.first_name"] = {:is => :text, :is_not => :text, :contains => :text}
    defs[:"user.last_name"] = {:is => :text, :is_not => :text, :contains => :text}
    defs[:"user.sex"] = {:is => :list, :is_not => :list}
    defs
  end

  def value_options_for(criteria_key)
    if criteria_key == :"user.sex"
      return ["male", "female"]
    end

    return []
  end

  def default_filters
    [
      ["Created Today", "created_today"],
      ["Start Tomorrow", "start_tomorrow"],
      ["Created By Users With Name 'Susan'", "created_by_susans"],
      ["Created By Male Users And Start Tomorrow", "male_creators_start_tomorrow"]
    ]
  end

  def default_filter_conditions(key)
    return [:created_at, :is_on, Date.today] if (key == "created_today")
    return [:start_time, :is_on, Date.today + 1.day] if (key == "start_tomorrow")
    return [:"user.first_name", :is, "Susan"] if (key == "created_by_susans")
    if (key == "male_creators_start_tomorrow")
      return [[:"user.sex", :is, "male"], [:start_time, :is_on, Date.today + 1.day]]
    end
  end

  def inner_joins
    [:user]
  end

end
