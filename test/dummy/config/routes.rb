Rails.application.routes.draw do

  mount WillFilter::Engine => "/will_filter"

  get 'simple/users'
  get 'simple/events'
  get 'simple/event_members'
  get 'advanced/users'
  get 'advanced/users_with_actions'
  get 'advanced/events'
  get 'advanced/event_members'

  get 'orders/index', :to => "orders#index"
  get 'orders/items'
  
  root :to => 'simple#users'
end
