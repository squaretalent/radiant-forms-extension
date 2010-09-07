class FormsExtension < Radiant::Extension
  version     '2.0'
  description 'Radiant Form extension. Site wide, useful form management'
  url         'http://github.com/squaretalent/radiant-forms-extension'
  
  extension_config do |config|
    if RAILS_ENV == :test
      config.gem 'rr',        :version => '0.10.11'
    end
  end
  
  def activate
    # View Hooks
    unless defined? admin.form
      Radiant::AdminUI.send :include, Forms::Interface::Core
      
      admin.form = Radiant::AdminUI.load_default_form_regions
    end
    
    # Model Includes
    Page.send :include, Forms::Tags::Core, Forms::Models::Page
    
    # Controller Includes
    ApplicationController.send :include, Forms::Controllers::ApplicationController
    SiteController.send :include, Forms::Controllers::SiteController
    
    tab 'Design' do
      add_item 'Forms', '/admin/forms', :after => 'Snippets'
    end
  end
end
