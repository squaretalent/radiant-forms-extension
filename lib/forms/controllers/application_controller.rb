module Forms
  module Controllers
    module ApplicationController
      
      def self.included(base)
        base.class_eval do
          def current_response
            return @current_response if defined?(@current_response)
            @current_response = find_or_create_response if request.session[:form_response]
          end
          
          def find_response
            begin
              response = Response.find(request.session[:form_response])
            rescue
              response = nil
            end
          end
          
          def find_or_create_response
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