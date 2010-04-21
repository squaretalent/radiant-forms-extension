module FormTags
  include Radiant::Taggable
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::FormOptionsHelper
  
  class TagError < StandardError; end
  
  desc %{ Render a form based on its name }
  tag 'form' do |tag|
    results = []
    if name = tag.attr['name']
      if tag.locals.form = Form.first(:first, :conditions => {:title => name.strip})
        tag.attr['id'] ||= "form_" + tag.locals.form.title
        tag.attr['method'] ||= "post"
        tag.attr['action'] = tag.locals.form.action.empty? ? "/form/"+tag.locals.form.id.to_s : tag.locals.form.action
        
        results << %(<form enctype="multipart/form-data" #{form_attrs(tag)}>\n)
        results << %(<input type="hidden" name="page" value="#{tag.locals.page.id}" />\n)
        results << render_form(tag.locals.form)
        results << %(</form>)
      else
        raise TagError, "form not found"
      end
    else
      results << tag.expand
    end
    results
  end

  desc %{ form:label }
  tag 'form:label' do |tag|
    
    @for = tag.attr['for']
    @for = @for.gsub('[','_').gsub(']','') unless @for.nil?
    
    attrs = {
      :for => @for
    }
    
    result = [%(<label #{form_attrs(tag, attrs)}>#{tag.expand}</label>)]
  end

  %w(text password reset checkbox radio hidden file).each do |type|
    desc %{ Renders a #{type} input tag for a mailer form. The 'name' attribute is required.}
    tag "form:#{type}" do |tag|
      raise_error_if_name_missing "form:#{type}", tag.attr
      value = tag.attr['value']
      tag.attr['type'] = type
      result = [%(<input type="#{type}" value="#{value}" #{form_attrs(tag)} />)]
    end
  end
  
  desc %{
    Renders a @<select>...</select>@ tag for a form.  The 'name' attribute is required.
    @<r:option />@ tags may be nested inside the tag to automatically generate options.}
  tag 'form:select' do |tag|
    raise_error_if_name_missing "form:select", tag.attr
    tag.locals.parent_tag_name = tag.attr['name']
    tag.locals.parent_tag_type = 'select'
    result = [%Q(<select #{form_attrs(tag, 'size' => '1')}>)]
    result << tag.expand
    result << "</select>"
  end
  
  desc %{
    Renders a series of @<input type="radio" .../>@ tags for a form.  The 'name' attribute is required.
    Nested @<r:option />@ tags will generate individual radio buttons with corresponding values. }
  tag 'form:radios' do |tag|
    raise_error_if_name_missing "form:radios", tag.attr
    tag.locals.parent_tag_name = tag.attr['name']
    tag.locals.parent_tag_type = 'radios'
    tag.expand
  end
  
  desc %{ Renders an @<option/>@ tag if the parent is a
      @<r:form:select>...</r:form:select>@ tag, an @<input type="radio"/>@ tag if
      the parent is a @<r:form:radios>...</r:form:radios>@ }
  tag 'form:option' do |tag|
    if tag.locals.parent_tag_type == 'radios'
      tag.attr['name'] ||= tag.locals.parent_tag_name
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
  
  desc %{ Renders a list of countries }
  tag 'form:countries' do |tag|
    value = tag.attr['value'] || nil
    result = [%Q(<select #{form_attrs(tag, 'size' => '1')}>)]
    result << country_options_for_select(value)
    result << "</select>"

  end

  def form_attrs(tag, extras={})
    @id = tag.attr['name']
    @id = @id.gsub('[','_').gsub(']','') unless @id.nil?
    
    attrs = {
      'id'            => @id,  
      'class'         => tag.attr['type'],
      'method'        => nil,
      'action'        => nil,
      'autocomplete'  => nil,
      'size'          => nil}.merge(extras)
      
    result = attrs.collect do |k,v|
      v = (tag.attr[k] || v)
      next if v.blank?
      %(#{k}="#{v}")
    end.reject{|e| e.blank?}
    result << %(name="#{tag.attr['name']}") unless tag.attr['name'].blank?
    result.join(' ')
  end
  
  # accessing data when processing a form
  
  tag 'form:get' do |tag|
    name = tag.attr['name']
    data = hash_retrieve(tag.locals.page.data, name) if name
    data.to_s
  end
  
  # accessing response of processing a form
  
  tag 'form:response' do |tag|
    tag.locals.form_response = find_form_response(tag)
    tag.expand unless tag.locals.form_response.result.nil?
  end
  
  tag 'form:response:clear' do |tag|
    clear_form_response(tag)
    nil
  end

  tag 'form:response:get' do |tag|
    name = tag.attr['name']
    results = hash_retrieve(tag.locals.form_response.result, name)
    results unless results.nil?
  end
  
protected

  def prior_value(tag, tag_name=tag.attr['name'])
    nil
  end

  def render_form(form)
    string = "<r:form>"
    string << form.body
    string << "</r:form>"
  
    text = parse(string)
  end

  def raise_error_if_name_missing(tag_name, tag_attr)
    raise "'#{tag_name}' tag requires a 'name' attribute" if tag_attr['name'].blank?
  end

  def find_form_response(tag)
    if tag.locals.form_response
      tag.locals.form_response
    else
      Response.find(request.session[:form_response])
    end
  end
  
  def clear_form_response(tag)
    tag.locals.form_response.result = nil
    tag.locals.form_response.save
  end
  
  # takes object[value] || value and accesses the hash as hash[object][value] || hash[value]
  def hash_retrieve(hash, array)
    data = array.gsub("[","|").gsub("]","").split("|") rescue nil
    
    result = false
    result = hash.fetch(data[0]) unless data.nil?
    result = result.fetch(data[1]) if !data.nil? and data[1]
  end
  
end