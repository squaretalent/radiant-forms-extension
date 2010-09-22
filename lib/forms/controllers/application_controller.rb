module Forms
  module Controllers
    module ApplicationController
      
      def self.included(base)
        base.class_eval do
          def current_response
            return @current_response if defined?(@current_response)
            @current_response = find_response
          end
          
          def find_response
            response = nil
            
            if request.session[:form_response]
              response = Response.find(request.session[:form_response])
            end
                        
            response
          end
          
          def find_or_create_response
            response = nil
            
            if find_response
              response = find_response
            else
              response = Response.create
              request.session[:form_response] = response.id
            end
            
            response
          end
        end
      end
      
    end
  end
end