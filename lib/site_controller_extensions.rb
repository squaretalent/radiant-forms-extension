module Forms
  module SiteControllerExtensions
    def self.included(base)
      base.class_eval {
        before_filter :initialize_response
        
        def initialize_response
          if request.session[:form_response]
            @response = Response.find(request.session[:form_response]) rescue new_response
          else
            @response = new_response
          end
        end
        
        def new_response
          @response = Response.create
          request.session[:form_response] = @response.id
          @response
        end
      }
    end
  end
end