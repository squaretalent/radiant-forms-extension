class TagError < StandardError; end

module Forms
  module Tags
    module Core
      include Radiant::Taggable
      
      desc %{
        Render a form and its contents
        <pre><code><r:form name="object[key]" [method, url] /></code></pre>
        
        * *name* the name of the form
        * *method* url submission method [ post, get, delete, put ]
        * *url* address to submit the form to
      }
      tag 'form' do |tag|
        if tag.attr['name'].present?
          if tag.locals.form = Form.find_by_title(tag.attr['name'])
            tag.attr['id'] ||= 'form_' + tag.locals.form.title
            tag.attr['method'] ||= 'put'
            tag.attr['action'] ||= tag.locals.form.action.blank? ? "/forms/#{tag.locals.form.id}" : tag.locals.form.action
            
            parse(Forms::Tags::Helpers.render(tag))
          else
            raise TagError, "Could not find '#{tag.attr['name']}' form"
          end
        else
          tag.expand
        end
      end
      
      desc %{ 
        Render a @<label />@ tag to be used inside a form
        <pre><code><r:form:label for="object[key]" /></code></pre>
        
        **Required**
        * *for* the name of the field you are relating the tag to
        
        _A label is a piece of text which activates its related input when clicked_
      }
      tag 'form:label' do |tag|
        Forms::Tags::Helpers.require!(tag,'form:label','for')
        
        tag.attr['for'] = tag.attr['for'].gsub('[','_').gsub(']','') unless tag.attr['for'].nil?
        
        %(<label #{Forms::Tags::Helpers.attributes(tag)}>#{tag.expand}</label>)
      end
      
      %w(text password reset checkbox radio hidden file button).each do |type|
        desc %{
          Render a @<#{type}>...</#{type}>@ tag to be used in a form
          <pre><code><r:form:#{type} name="object[key]" /></code></pre>
          
          **Required**
          * *name* the name of the data to be sent
          
          **Optional**
          * *class* css class names
          * *placeholder* default text, which is cleared when clicked
          * *maxlength* the maximum amount of characters
        }
        tag "form:#{type}" do |tag|
          Forms::Tags::Helpers.require!(tag,"form:#{type}",'name')
          
          value = tag.attr['value']
          tag.attr['type'] = type
          
          %(<input type="#{type}" value="#{value}" #{Forms::Tags::Helpers.attributes(tag)} />)
        end
      end

      %w(textarea).each do |type|
        desc %{
          Render a @<#{type}>...</#{type}>@ tag to be used in a form
          <pre><code><r:form:#{type} name="object[key]" /></code></pre>
          
          **Required**
          * *name* the name of the data to be sent
          
          **Optional**
          * *class* css class names
          * *placeholder* default text, which is cleared when clicked
          * *maxlength* the maximum amount of characters
        }
        tag "form:#{type}" do |tag|
          Forms::Tags::Helpers.require!(tag,"form:#{type}",'name')
          
          tag.attr['type'] = type
          
          %(<#{type} #{Forms::Tags::Helpers.attributes(tag)}>#{tag.expand}</#{type}>)
        end
      end
      
      desc %{
        Renders a @<select>...</select>@ tag to be used in a form
        
        <pre><code><r:form:select name="object[key]"><r:option value="text" /></r:form:select></code></pre>
        
        **Required**
        * *name* the name of the data to be sent
        
        **Optional**
        * *class* css class names
        
        _@<r:option />@ tags may be nested inside the tag to automatically generate options_
      }
      tag 'form:select' do |tag|
        Forms::Tags::Helpers.require!(tag,'form:select','name')
        
        tag.locals.parent_tag_name = tag.attr['name']
        tag.locals.parent_tag_type = 'select'
        
        %(<select #{Forms::Tags::Helpers.attributes(tag)}>#{tag.expand}</select>)
      end
      
      desc %{
        Renders a series of @<input type="radio"/>@ tags to be used in a form
        
        <pre><code><r:form:radios name="object[value]" value="text"><r:option value="text" /></r:form:radios></code></pre>
        
        **Required**
        * *name* the name of the data to be sent
        
        **Optional**
        * *class* css class names
        
        _@<r:option />@ tags may be nested inside the tag to automatically generate options_
      }
      tag 'form:radios' do |tag|
        Forms::Tags::Helpers.require!(tag,'form:radios','name')
        
        tag.locals.parent_tag_name = tag.attr['name']
        tag.locals.parent_tag_type = 'radios'
        tag.expand
      end
      
      desc %{
        Renders an @<option/>@ tag if the parent is a
        @<r:form:select>...</r:form:select>@ or @<r:form:radios>...</r:form:radios>@
        
        **Required**
        * *value* the value you want to be sent if selected
      }
      tag 'form:option' do |tag|
        value = tag.attr['value'] || tag.expand
        
        if tag.locals.parent_tag_type == 'select'
          text = tag.expand.length == 0 ? value : tag.expand
          
          extra = { 'value' => value}
          %(<option #{Forms::Tags::Helpers.attributes(tag, extra)}>#{text}</option>)
        elsif tag.locals.parent_tag_type == 'radios'
          name= tag.locals.parent_tag_type == 'radios' ? tag.locals.parent_tag_name : tag.attr['name']
          id  = name.gsub('[','_').gsub(']','') + '_' + value
          
          extra = { 'id' => id, 'value' => value, 'name' => name, 'type' => 'radio' }
          %(<input #{Forms::Tags::Helpers.attributes(tag, extra)} />)
        end
      end
      
      desc %{
        Renders an @<input type="submit" />@ tag for a form.
        
        **Optional**
        * *value* the text on the submit
      }
      tag 'form:submit' do |tag|
        value = tag.attr['value'] || 'submit'
        extra = { 'value' => value, 'type' => 'submit', 'class' => 'submit', 'name' => 'submit' }
        %(<input #{Forms::Tags::Helpers.attributes(tag, extra)} />)
      end
      
      desc %{
        Query the data from a submitted form
        
        @<r:form:read name="object[value]" />@ access the object which was submitted
        
        _This can only be used in the content section of a form, use @<r:form:get />@ in pages_
      }
      tag 'form:read' do |tag|
        Forms::Tags::Helpers.require!(tag,'form:read','name')
        tag.locals.form_data ||= tag.locals.page.data
        
        tag.locals.form_data = Forms::Tags::Responses.retrieve(tag.locals.form_data, tag.attr['name'])
        
        tag.expand.present? ? tag.expand : tag.locals.form_data
      end
      
      tag 'form:read:each' do |tag|
        result = ''
        
        fields = tag.locals.form_data
        fields.each do |index,data|
          tag.locals.form_data = data
          result << tag.expand
        end
        
        result
      end
      
      desc %{ 
        Allows access to the response of a submitted form
        @<r:response>...<r:get /><r:clear />...</r:response>@
      }
      tag 'response' do |tag|
        tag.locals.response = Forms::Tags::Responses.current(tag,request)
        
        tag.expand
      end
      
      desc %{ 
        Expands if a response object exists in the user session
      }
      tag 'response:if_response' do |tag|
        tag.expand if tag.locals.response.present? and tag.locals.response.result.present?
      end
      
      desc %{ 
        Expands unless a response object exists in the user session
      }
      tag 'response:unless_response' do |tag|
        tag.expand if tag.locals.response.blank? or tag.locals.response.result.blank?
      end
      
      desc %{
        Clears the response object
        
        @<r:response:clear />@
      }
      tag 'response:clear' do |tag|
        if tag.locals.response.present? and tag.locals.response.result.present?
          Forms::Tags::Responses.clear(tag)
        end
        
        tag.expand
      end

      desc %{ Expand if there is a response to a specified for value }
      tag 'response:if_results' do |tag|
        extension = tag.attr['extension'].to_sym
        if tag.locals.response.result.present?
          tag.locals.response_extension = tag.locals.response.result[:results][extension]
          
          if tag.locals.response_extension.present?
            tag.expand
          end
        end
      end
      
      desc %{ Expand if there is a response to a specified for value }
      tag 'response:unless_results' do |tag|
        extension = tag.attr['extension'].to_sym
        
        unless tag.locals.response.result.present?
          tag.expand
        else
          tag.locals.response_extension = tag.locals.response.result[:results][extension]
          
          unless tag.locals.response_extension.present?
            tag.expand
          end
        end
      end
      
      desc %{ Expand if there is a positive response to a specified for value of an extension
        
        @<r:response:if_get extension='bogus_gateway' name='checkout'>yay</r:response:if_get>@
      }
      tag 'response:if_get' do |tag|
        if tag.locals.response_extension.present?
          query = tag.attr['name'].to_sym
          result = tag.locals.response_extension[query]
        
          tag.expand if result
        end
      end
      
      desc %{ Expand if there is a negative response to a specified for value of an extension
        
        @<r:response:unless_get extension='bogus_gateway' name='checkout'>no</r:response:unless_get>@
      }
      tag 'response:unless_get' do |tag|
        if tag.locals.response_extension.present?
          query = tag.attr['name'].to_sym
          result = tag.locals.response_extension[query]
        
          tag.expand unless result
        else
          tag.expand
        end
      end
      
      desc %{ 
        Access the attributes of a submitted form.
        
        @<r:response:get name="object[value]" />@ an object which was submitted with the form
        @<r:response:get name="results[mail][value]" />@ a response to the mail extension hooking the form
        
        _Refer to the readme on extensions to find out what they return_
      }
      tag 'response:get' do |tag|
        Forms::Tags::Helpers.require!(tag,'response:get','name')
        
        result = Forms::Tags::Responses.retrieve(tag.locals.response.result, tag.attr['name']).to_s
      end
      
      desc %{
        Renders the numeric index value of an arbitrary array name incrementing this
        value after every call.
        *Usage:* _The following would render '0012'
        <pre><code><r:index [array="widgets"] /><r:index array="snippets" /><r:index [array="widgets"] /><r:index [array="widgets"] /></code></pre>
      }
      tag 'index' do |tag|
        key = tag.attr['array'] ||= 'array'

        if tag.globals.indexes.present? # If the global indexes array exists
          if tag.globals.indexes[key].nil? # Set the value of that index to zero if not present
            tag.globals.indexes[key] = 0
          end
        else
          tag.globals.indexes = { key => 0 } # Create the indexes array and that index
        end

        index = tag.globals.indexes[key] # Store the current value for return
        tag.globals.indexes[key] += 1 # Increment the index value on the global object

        index # Return the stored index
      end

      desc %{
        Resets the counter on an array
        *Usage:* _The following with render '010'
        <pre><code><r:index [array="widgets"] /><r:index [array="widgets"] /><r:reset [array="widgets"] /><r:index [array="widgets"] /></code></pre>
      }
      tag 'reset' do |tag|
        key = tag.attr['array'] ||= 'array'
        tag.globals.indexes[key] = 0
        nil
      end
      
      tag 'param' do |tag|
        tag.locals.page.params[tag.attr['name']]
      end
      
    end
  end
end