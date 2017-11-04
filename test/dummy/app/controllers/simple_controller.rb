class SimpleController < ApplicationController

  def users
    @users = User.filter(:params => params.permit!)
  end

  def events
    @events = Event.filter(:params => params.permit!)
  end

  def event_members
    @event_users = EventUser.filter(:params => params.permit!)
  end

end
