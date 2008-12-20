ActionController::Routing::Routes.draw do |map|
  map.resources :db_instances

  map.resources :apps do |apps|
    apps.resources :activities do |activities|
      activities.resources :changes, :collection => {:suggest_new => :get, :suggest => :post}
      activities.resources :versions
    end
  end
  
  map.connect 'flash/:action', :controller => 'flash'
  
  # You can have the root of your site routed with map.root
  map.root :controller => "apps"
end
