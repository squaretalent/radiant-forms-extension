module Forms
  module Tags
    include Radiant::Taggable
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::FormOptionsHelper
  
    class TagError < StandardError; end
  
    desc %{
      Render a form and its contents
      <pre><code><r:form name="object[key]" [method, url] /></code></pre>
      * *name* the name of the form
      * *method* url submission method [ post, get, delete, put ]
      * *url* address to submit the form to
    }
    tag 'form' do |tag|
      
      unless tag.attr['name'].blank?
        if tag.locals.form = Form.find_by_title(tag.attr['name'])
          tag.attr['id'] ||= 'form_' + tag.locals.form.title
          tag.attr['method'] ||= 'post'
          tag.attr['action'] ||= tag.locals.form.action.empty? ? '/form/'+tag.locals.form.id.to_s : tag.locals.form.action      
          return render_form(tag.locals.form, tag)
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
      raise_error_if_missing 'form:label', tag.attr, 'for'
      
      tag.attr['for'] = tag.attr['for'].gsub('[','_').gsub(']','') unless tag.attr['for'].nil?
    
      result = [%(<label #{form_attrs(tag)}>#{tag.expand}</label>)]
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
        raise_error_if_missing "form:#{type}", tag.attr, 'name'
        
        value = tag.attr['value']
        tag.attr['type'] = type
        result = [%(<input type="#{type}" value="#{value}" #{form_attrs(tag)} />)]
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
      raise_error_if_missing 'form:select', tag.attr, 'name'
      
      tag.locals.parent_tag_name = tag.attr['name']
      tag.locals.parent_tag_type = 'select'
      
      result = [%Q(<select #{form_attrs(tag, 'size' => '1')}>)]
      result << tag.expand
      result << "</select>"
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
      raise_error_if_missing 'form:radios', tag.attr, 'name'
      
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
      if tag.locals.parent_tag_type == 'radios'
        tag.attr['name'] = tag.locals.parent_tag_name
      end
      value = (tag.attr['value'] || tag.expand)
      prev_value = prior_value(tag, tag.locals.parent_tag_name)
      checked = tag.attr.delete('selected') || tag.attr.delete('checked')
      selected = prev_value ? prev_value == value : checked

      if tag.locals.parent_tag_type == 'select'
        %(<option value="#{value}"#{%( selected="selected") if selected} #{form_attrs(tag)}>#{tag.expand}</option>)
      elsif tag.locals.parent_tag_type == 'radios'
        %(<input type="radio" value="#{value}"#{%( checked="checked") if selected} #{form_attrs(tag)} />)
      end
    end

    desc %{ Renders a submit input tag for a form. }
    tag 'form:submit' do |tag|
      value = tag.attr['value'] || 'submit'
      tag.attr.merge!("name" => "button")

      result = [%(<input type="submit" value="#{value}" class="submit" #{form_attrs(tag)} />)]
    end
  
    # accessing response of processing a form
    tag 'form:response' do |tag|
      tag.locals.form_response = find_form_response(tag)
      
      tag.expand unless tag.locals.form_response.result.nil?
    end
  
    tag 'form:response:clear' do |tag|
      clear_form_response(tag)
    end

    tag 'form:response:get' do |tag|
      raise_error_if_missing 'form:response:get', tag.attr, 'name'
      
      results = hash_retrieve(tag.locals.form_response.result, tag.attr['name'])
    end
  
    # accessing data when processing a form
    desc %{
      Retrieve data from a submitted form.
    }
    tag 'get' do |tag|
      raise_error_if_missing 'get', tag.attr, 'name'

      data = hash_retrieve(tag.locals.page.data, tag.attr['name']).to_s
    end
  
  protected
  
    def form_attrs(tag, extras={})
      @id = tag.attr['name'] || "label_for_#{tag.attr['for']}"
      @id = @id.gsub('[','_').gsub(']','') unless @id.nil?
    
      attrs = {
        'id'            => @id,  
        'class'         => tag.attr['type'],
        'name'          => nil,
        'for'           => nil,
        'method'        => nil,
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

    def prior_value(tag, tag_name=tag.attr['name'])
      #TODO make work with hash_retrieve
    end

    def render_form(form, tag)
      string =  %(<form enctype="multipart/form-data" #{form_attrs(tag)}>\n)
      string << %(<input type="hidden" name="page" value="#{tag.locals.page.id}" />\n)
      string << "<r:form>"
      string << form.body
      string << "</r:form>"
      string << %(</form>)
      
      text = parse(string)
    end

    def raise_error_if_missing(tag_name, tag_attr, name)
      raise "'#{tag_name}' tag requires a '#{name}' attribute" if tag_attr[name].blank?
    end

    def find_form_response(tag)
      if tag.locals.form_response
        tag.locals.form_response
      else
        Response.find(request.session[:form_response])
      end
    end
  
    def clear_form_response(tag)
      tag.locals.form_response.update_attribute('result', nil)
    end
  
    # takes object[key] or value 
    # Accesses the hash as hash[object][value]
    # Accesses the value as hash[value]
    def hash_retrieve(hash, array)
      data = array.gsub("[","|").gsub("]","").split("|") rescue nil
    
      result = false
      result = hash.fetch(data[0]) unless data.nil?
      result = result.fetch(data[1]) if !data.nil? and data[1]
    end
  
  end
end