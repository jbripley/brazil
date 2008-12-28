ActionController::Routing::Routes.draw do |map|
  map.resources :db_instances

  map.resources :apps, :except => [:destroy] do |apps|
    apps.resources :activities, :except => [:destroy] do |activities|
      activities.resources :changes, :except => [:destroy]
      activities.resources :change_suggestions, :only => [:new, :create]
      activities.resources :versions, :except => [:destroy]
    end
  end
  
  map.connect 'flash/:action', :controller => 'flash'
  
  # You can have the root of your site routed with map.root
  map.root :controller => "apps"
end
