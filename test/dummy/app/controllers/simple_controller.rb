class SimpleController < ApplicationController

  def users
    @users = User.filter(:params => params)
  end

  def events
    @events = Event.filter(:params => params)    
  end

  def event_members
    @event_users = EventUser.filter(:params => params)    
  end

end
