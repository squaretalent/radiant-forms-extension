module Forms
  module ApplicationControllerExtensions
    def self.included(base)
      base.class_eval {
        helper_method :current_response
        
        def current_response
          @response = Response.find(request.session[:form_response])
        end
      }
    end
  end
end