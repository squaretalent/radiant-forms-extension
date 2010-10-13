require File.dirname(__FILE__) + '/../spec_helper'

describe Form do
  dataset :forms
  
  describe '#attributes' do
    
    before :all do
      @form = forms(:test)
    end
    
    it 'should have a title string' do
      @form.title.is_a?(String).should == true
    end
    
    it 'should have an action string' do
      @form.action = ''
      @form.action.is_a?(String).should == true
    end
    
    it 'should have a redirect_to string' do
      @form.redirect_to = ''
      @form.redirect_to.is_a?(String).should == true
    end
    
    it 'should have a body string' do
      @form.body.is_a?(String).should == true
    end
    
    it 'should have an content string' do
      @form.content.is_a?(String).should == true
    end
    
    it 'should have an secondary string' do
      @form.secondary.is_a?(String).should == true
    end
    
    it 'should have a config string' do
      @form.config.is_a?(String).should == true
    end
    
  end
  
end