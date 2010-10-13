class FormTest
include Forms::Models::Extension
  def create
    result = { :response => 'test' }
  end
end

class FormAlt
  include Forms::Models::Extension
  def create
    result = { :response => 'alt' }
  end
end

class FormsDataset < Dataset::Base
  
  def load
    attributes = {
      :title        => "test_form",
      :body         => "<r:text name='request[test]' />",
      :content      => "<r:form:read name='request[test]' />",
      :secondary    => "<r:form:read name='request[test]' />",
      :config       => <<-CONFIG
test:
  extension: test
CONFIG
    }
    create_record :form, :test, attributes
  end
  
end