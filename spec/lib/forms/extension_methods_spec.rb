require File.dirname(__FILE__) + '/../../spec_helper'

describe Forms::ExtensionMethods do
  dataset :forms, :pages
  
  before :each do
    @page = pages(:home)
    @form = forms(:test)
  end
  
  context 'initializer' do
        
    it 'should expect a form and page object' do
      lambda { FormsTestController.new(@form, @page) }.should_not raise_error
    end
    
  end
    
  context 'instance variables' do
    
    before :each do
      @forms_test = FormsTestController.new(@form, @page)
    end
    
    it 'should have a forms attribute' do
      @forms_test.form.should be_an_instance_of(Form)
      @forms_test.form.should == @form
    end
    
    it 'should have a page attribute' do
      @forms_test.page.should be_an_instance_of(Page)
      @forms_test.page.should == @page
    end
    
    it 'should have a data attribute' do
      @forms_test.data.should == @page.data
    end
    
  end
  
end