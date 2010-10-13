module Forms
  module Models
    module Extension
      def self.included(base)
        base.class_eval do
          def initialize(form, page)
            @form   = form
            @page   = page

            @data   = Forms::Config.deep_symbolize_keys(@page.data)

            # Set the environment in page data for future reference
            environment = self.class.to_s.underscore.gsub('form_', '').to_sym
            @page.environment = environment

            # Sets the config to be the current environment config: checkout:
            @config = @form[:extensions][environment]
          end

          def current_user
            return @current_user if @current_user.present?
            @current_user = UserActionObserver.current_user
          end

        end
      end
    end
  end
end
