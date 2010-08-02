require File.dirname(__FILE__) + '/../spec_helper'

describe Response do
  
  before :each do
    @response = Response.new
    @object   = { 'test' => 'test' }
  end
  
  context 'setting' do
    
    it 'should store an object' do
      @response.result.should be_nil
      @response.result = @object
      @response.result.should_not be_nil
    end
    
    it 'should return an object' do
      @response.result_json = @object.to_json
      @response.result.should_not be_nil
      @response.result == @object
    end
    
    it 'should set and return the same object' do
      @response.result = @object
      @response.result.should == @object
    end
    
  end
  
end