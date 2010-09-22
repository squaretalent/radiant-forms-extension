module Forms
  module Controllers
    module SiteController
      
      def self.included(base)
        base.class_eval do
          before_filter :current_response
        end
      end
      
    end
  end
end