require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/form_page_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/forms_admin_ui"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/form_tags"

require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/application_controller_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/site_controller_extensions"

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
    
    Page.class_eval { include FormTags, FormPageExtensions }
    ApplicationController.send(:include, Forms::ApplicationControllerExtensions)
    SiteController.send(:include, Forms::SiteControllerExtensions)
    
    tab 'Design' do
      add_item 'Forms', "/admin/forms", :after => 'Snippets'
    end
    
  end
  
end
