class FormsExtension < Radiant::Extension
  version     '2.0'
  description 'Radiant Form extension. Site wide, useful form management'
  url         'http://github.com/squaretalent/radiant-forms-extension'
  
  # extension_config do |config|
  #   config.gem 'some-awesome-gem
  #   config.after_initialize do
  #     run_something
  #   end
  # end
  
  def activate
    Radiant::AdminUI.send(:include, Forms::AdminUI) unless defined? admin.form
    admin.form = Radiant::AdminUI.load_default_form_regions
    
    Page.class_eval { include Forms::Tags, Forms::PageExtensions }
    ApplicationController.send(:include, Forms::ApplicationControllerExtensions)
    SiteController.send(:include, Forms::SiteControllerExtensions)
    
    tab 'Design' do
      add_item 'Forms', '/admin/forms', :after => 'Snippets'
    end
  end
end
