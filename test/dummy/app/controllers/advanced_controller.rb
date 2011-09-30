class AdvancedController < ApplicationController

  def users
    @users = User.filter(:params => params, :filter => :user_filter)
  end

  def users_with_actions
    @users = User.filter(:params => params, :filter => :user_filter)
  end

  def events
    @events = Event.filter(:params => params, :filter => :event_filter)    
  end

  def event_members
    @event_users = EventUser.filter(:params => params, :filter => :event_user_filter)    
  end

end
