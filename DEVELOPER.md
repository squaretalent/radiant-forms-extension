# Extending Radiant Forms

The whole point of forms is that you can build an extension which allows you to hook the process method of any form.

To do this you simply use an **alias_method_chain**

## Getting Started

### forms_cool_extension.rb
    
    def activate
      # Extend the Standard form controller
      FormController.class_eval do
        # We need to include the controller with the chaining method
        include FormCoolController
        alias_method_chain :process_form, :coolness
      end
    end
    
### app/controllers/form_cool_controller.rb
    
    module FormCoolController
      
      def process_form_with_coolness(form, data, page, response)
        
        # We're extending a controller, the method names must be unique (REST suffers)
        result = cool!(form, data, page)
        
        # Merging the result into the response object
        response.result = response.result.merge(result)
        
        # This is absolutely required, it allows for multiple chains
        process_form_without_coolness(form, data, page, response)
        
      end
      
      def cool!(form, data, page)
        
        # Only call the method if the form is configured to be cool
        unless form.config.nil? or form.config[:cool].nil?
          @cool = Cool.new(form, data, page)
          
          @cool.process!
        end
        
        # Create a result hash, to be merged with the Response.result hash
        result = { :cool => nil }
        unless @cool.nil?
          result = {
            :cool => {
              :success => @cool.success?,
              :message => @cool.message
            }
          }
        end
        result
      end
      
    end
    
### app/models/cool.rb
    
    class Cool
      attr_reader :config, :data
      
      def initialize(form, data, page)
        # We're only interested in the cool configuration
        @data, @config = data, form.config[:cool]
        
        # If you need to access the body information, this will render the tags appropriately
        @body = page.render_snippet(form)
      end
      
      def process!
        # Do whatever feels coolest
        @success = true
        @message = "This could be an error or success message"
      end
      
      def success?
        @success || false
      end
      
      def message
        @message || nil
      end
    
    end