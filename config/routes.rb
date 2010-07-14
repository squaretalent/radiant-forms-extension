ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin, :member => { :remove => :get } do |admin|
    admin.resources :forms
  end
  
  map.forms "/form/:id", :controller => "form", :action => "create"
  
end