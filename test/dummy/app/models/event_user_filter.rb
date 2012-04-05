class EventUserFilter < WillFilter::Filter

  def model_class
    EventUser
  end

  def inner_joins
    [:user, :event]
  end

  def definition
    defs = super  
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
      ["Events That Start Tomorrow And Attended By Users With Name 'David'", "start_tomorrow_with_davids"],
      ["Events That Start Tomorrow And Attended By Laddies Who Are 18 And Older", "start_tomorrow_with_females"]
    ]
  end

  def default_filter_conditions(key)
    if (key == "start_tomorrow_with_davids")
      return [[:"event.start_time", :is_on, Date.today + 1.day],
              [:"user.first_name", :is, 'David']]
    end  
    if (key == "start_tomorrow_with_females")
      return [[:"event.start_time", :is_on, Date.today + 1.day],
              [:"user.sex", :is, 'female'],
              [:"user.birthday", :is_after, Date.today - 18.years]]
    end  
  end

end
