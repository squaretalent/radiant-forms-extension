module Forms
  module Tags
    module Responses
      
      class << self
        
        def current(tag, request)
          response = nil
          
          if tag.locals.response.present?
            response = tag.locals.response
          elsif tag.locals.page.request.present?
            session = tag.locals.page.request.session[:form_response] rescue tag.locals.page.request[:session][:form_response]
            begin
              response  = Response.find(session)
            rescue
              if session == Object
                response  = Response.create
                tag.locals.page.request.session[:form_response] = result.id
              end
            end
          end
          
          response
        end
      
        # Returns the value from a hash when in input key is sent 
        # @source = hash
        # @key 
        def retrieve(source, key)
          result = nil
          
          if source.present?
            data = key.gsub("[","|").gsub("]","").split("|")
            
            if data.present?
              result = source.fetch(data[0].to_sym)
              data.delete_at(0)
              
              if data.length and result.present?
                data.each do |i|
                  result = result.fetch(i.to_sym) rescue nil
                end
              end
            end
          end
          
          result
        end
        
        def clear(tag)
          tag.locals.response.update_attribute('result', nil)
        end
      
      end
    end
  end
end