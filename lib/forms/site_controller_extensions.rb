module Forms
  module SiteControllerExtensions
    def self.included(base)
      base.class_eval {
        before_filter :find_response
        
        def find_response
          if request.session[:form_response]
            @response = Response.find(request.session[:form_response])
          else
            @response = nil
          end
          
          @response
        end
      }
    end
  end
end