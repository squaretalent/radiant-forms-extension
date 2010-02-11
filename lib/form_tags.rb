module FormTags
  include Radiant::Taggable
  include ActionView::Helpers::DateHelper
  
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
    result = [%(<label #{form_attrs(tag)}>#{tag.expand}</label>)]
  end

  %w(text password reset checkbox radio hidden file).each do |type|
    desc %{ Renders a #{type} input tag for a mailer form. The 'name' attribute is required.}
    tag "form:#{type}" do |tag|
      raise_error_if_name_missing "form:#{type}", tag.attr
      value = tag.attr['value']
      result = [%(<input type="#{type}" value="#{value}" #{form_attrs(tag)} />)]
    end
  end

  desc %{ Renders a submit input tag for a form. }
  tag 'form:submit' do |tag|
    value = tag.attr['value'] || 'submit'
    tag.attr.merge!("name" => "button")

    result = [%(<input type="submit" value="#{value}" #{form_attrs(tag)} />)]
  end

  def form_attrs(tag, extras={})
    attrs = {
      'id' => tag.attr['name'],
      'class' => nil,
      'method' => nil,
      'action' => nil,
      'size' => nil}.merge(extras)
    result = attrs.collect do |k,v|
      v = (tag.attr[k] || v)
      next if v.blank?
      %(#{k}="#{v}")
    end.reject{|e| e.blank?}
    result << %(name="form[#{tag.attr['name']}]") unless tag.attr['name'].blank?
    result.join(' ')
  end
  
  def render_form(form)
    text = "<r:form>"
    text << form.body
    text << "</r:form>"
    text = parse(text)
    text = form.filter.filter(text) if form.respond_to? :filter_id
    text
  end
  
  def raise_error_if_name_missing(tag_name, tag_attr)
    raise "'#{tag_name}' tag requires a 'name' attribute" if tag_attr['name'].blank?
  end
  
  # accessing data within a former object
  
  tag 'get' do |tag|
    name = tag.attr['name']
    data = tag.locals.page.form[name]
    data.to_s
  end
  
end