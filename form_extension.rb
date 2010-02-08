# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class FormExtension < Radiant::Extension
  
  version "1.0"
  description "Radiant Form extension, generate easily hookable, reusabled and stylable forms"
  url "http://squaretalent.com/radiant/extensions/form"
  
  define_routes do |map|
    
    map.namespace :admin, :member => { :remove => :get }, :collection => { :refresh => :post } do |admin|
      admin.resources :forms
    end
    
    map.forms "/form/:id", :controller => "form", :action => "create"
  end
  
  def activate
    Radiant::AdminUI.send :include, FormsAdminUI unless defined? admin.form
    admin.form = Radiant::AdminUI.load_default_form_regions
   
    Page.class_eval do
      include FormTags
    end
    
    admin.nav[:design] << admin.nav_item("Forms", "/admin/forms")
  end
  
end
