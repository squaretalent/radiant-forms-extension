module Forms
  module Tags
    module Helpers
      
      class << self
        
        def render(tag)
          string =  %(<form enctype="multipart/form-data" method="post" #{attributes(tag)}>\n)
            string << %(<input type="hidden" name="_method" value="#{tag.attr['method']}"/>\n)
            string << %(<input type="hidden" name="page_id" value="#{tag.locals.page.id}" />\n)
            string << %(<input type="hidden" name="form_id" value="#{tag.locals.form.id.to_s}" />\n)
            string << "<r:form>"
              string << tag.locals.form.body
            string << "</r:form>"
          string << %(</form>)
        end
        
        def attributes(tag, extras={})
          id = tag.attr['name'] || extras['name']
          id = id || tag.attr['for'] + '_label' if tag.attr['for']
          id = id.gsub('[','_').gsub(']','') unless id.nil?

          attrs = {
            'id'            => id,  
            'class'         => tag.attr['type'],
            'name'          => nil,
            'for'           => nil,
            'action'        => nil,
            'placeholder'   => nil,
            'value'         => nil,
            'maxlength'     => nil
          }.merge(extras)
          
          result = attrs.collect do |k,v|
            v = (tag.attr[k] || v)
            next if v.blank?
            %(#{k}="#{v}")
          end.reject{|e| e.blank?}

          result.join(' ')
        end
        
        def require!(tag,name,key)
          if tag.attr[key].present?
            return true
          else
            raise "'<r:#{name} />' requires the '#{key}' attribute"
          end
        end
        
      end
      
    end
  end
end