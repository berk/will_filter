Rails.application.routes.draw do
  mount WillFilter::Engine => "/will_filter"

  match 'simple/users'
  match 'simple/events'
  match 'simple/event_members'
  match 'advanced/users'
  match 'advanced/users_with_actions'
  match 'advanced/events'
  match 'advanced/event_members'
  
  root :to => "simple#users"
end
