module Forms
  module ApplicationControllerExtensions
    def self.included(base)
      base.class_eval {
        helper_method :current_response
        
        def current_response
          if request.session[:form_response]
            @response = Response.find(request.session[:form_response])
          else
            @response = Response.create
            request.session = @response.id
          end
          
          @response
        end
      }
    end
  end
end