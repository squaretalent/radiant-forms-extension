class FormsExtension < Radiant::Extension
  
  version "1.0"
  description "Radiant Form extension, generate easily hookable, reusabled and stylable forms"
  url "http://github.com/squaretalent/radiant-forms-extension"
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get }, :collection => { :refresh => :post } do |admin|
      admin.resources :forms
    end
    
    map.forms "/form/:id", :controller => "form", :action => "create"
  end
  
  extension_config do |config|
    config.gem 'will_paginate', '2.3.12'
  end
  
  def activate
    Radiant::AdminUI.send :include, FormsAdminUI unless defined? admin.form
    admin.form = Radiant::AdminUI.load_default_form_regions
   
    Page.class_eval do
      attr_accessor :form
      include FormTags
    end
    
    tab 'Design' do
      add_item 'Forms', "/admin/forms", :after => 'Snippets'
    end
    
  end
  
end
