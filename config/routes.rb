Rails.application.routes.draw do 

  namespace :will_filter do
    match 'filter/index',                 :to => 'filter#index'
    match 'filter/add_condition',         :to => 'filter#add_condition'
    match 'filter/update_condition',      :to => 'filter#update_condition'
    match 'filter/remove_condition',      :to => 'filter#remove_condition'
    match 'filter/remove_all_conditions', :to => 'filter#remove_all_conditions'
    match 'filter/load_filter',           :to => 'filter#load_filter'
    match 'filter/save_filter',           :to => 'filter#save_filter'
    match 'filter/update_filter',         :to => 'filter#update_filter'
    match 'filter/delete_filter',         :to => 'filter#delete_filter'

    match 'calendar',                     :to => 'calendar#index'
    match 'calendar/index',               :to => 'calendar#index'

    match 'exporter',                     :to => 'exporter#index'
    match 'exporter/index',               :to => 'exporter#index'
    match 'exporter/export',              :to => 'exporter#export'
  end
end
