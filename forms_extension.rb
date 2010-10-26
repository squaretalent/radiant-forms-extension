class FormsExtension < Radiant::Extension
  version     '3.2.4'
  description 'Radiant Form extension. Site wide, useful form management'
  url         'http://github.com/squaretalent/radiant-forms-extension'
  
  extension_config do |config|
  end
  
  def activate
    # View Hooks
    unless defined? admin.form
      Radiant::AdminUI.send :include, Forms::Interface::Forms
      
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
