class FormsTestController
  include Forms::AddonMethods
  def create
    result = { :response => 'test' }
  end
end

class FormsAltController
  include Forms::AddonMethods
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
      :config       => <<-CONFIG
test:
  config: test
CONFIG
    }
    create_record :form, :test, attributes
  end
  
end