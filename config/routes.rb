ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin, :member => { :remove => :get } do |admin|
    admin.resources :forms
  end
  
  map.forms '/forms/:form_id', :controller => 'forms', :action => 'create', :conditions => { :method => :post }
  
end