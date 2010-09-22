module Forms
  module Models
    module Extension
      def self.included(base)
        base.class_eval do 
          def initialize(form, page)
            @form   = form
            @page   = page
            
            @data   = @page.data
            
            # Sets the config to be the current environment config: checkout:
            @config = @form[:config][self.class.to_s.downcase.gsub('form', '').to_sym]
          end
        end
      end
    end
  end
end