require File.dirname(__FILE__) + '/../spec_helper'

describe FormsController do
  dataset :pages, :forms
  
  context '#new' do
    
    it 'should redirect to :back' do
      request.env['HTTP_REFERER'] = '/back'
      @object = Object.new
      stub(@object).result = { :some => 'array'}

      mock(controller).find_or_create_response { @object }
      mock(@object).update_attribute(:result, nil)

      get :new
      
      response.should redirect_to("/back")
    end
  end
  
  context '#create' do
    
    before :each do
      @page = pages(:home)
      @form = forms(:test)
      @params = {
        'id'    => @form.id,
        'data'  => 'test'
      }
      mock(Page).find(anything) { @page }
      mock(Form).find(anything) { @form }
    end
    
    context 'initialize' do
      
      before :each do
        put :update, @params
      end
        
      it 'should assign the page' do
        assigns(:page).should == @page
      end
  
      it 'should assign the form' do
        assigns(:form).should == @form
      end
  
      it 'should put the params into the page data' do
        assigns(:page).data[:request].should == @params['request']
      end
  
      it 'should find/create a response object' do
        assigns(:response).should be_an_instance_of(Response)
      end
  
      it 'should add the params to the response result' do
        assigns(:response).result[:request].should == @params['request']
      end
      
    end
    
    context 'configuration' do

      before :each do
        put :update, @params
      end
      
      context 'configuration exists' do
        
        it 'should assign the configuration settings' do
          assigns(:form)[:extensions][:test][:extension].should == 'test'
        end
        
      end
      
      context 'configuration doesn\'t exist' do
        
        before :each do 
          @form.config = nil
        end
        
        it 'should raise a form not configured exception' do
          response.should raise_error
        end
        
      end
      
    end
  
    context 'extensions' do
      
      before :each do
        put :update, @params
      end
          
      context 'extension configured' do
      
        it 'should call that test extension' do
          assigns(:response).result[:results][:test].should == { :response => 'test' }
        end
        
        it 'should not call the alt extension' do
          assigns(:response).result[:results][:alt].should be_nil
        end
      
      end
    
    end
    
    context 'response' do
      
      context 'successfully save response' do
        
        before :each do
          stub(@response).save { true }
        end
        
        context 'form has a redirect url' do
          
          before :each do
            @form.redirect_to = '/redirect/url'
            put :update, @params
          end
          
          it 'should redirect to the form redirect url' do
            response.should redirect_to('/redirect/url')
          end
          
        end
        
        context 'form does not have a redirect url' do
          
          before :each do
            @page.slug = '/page/url'
            put :update, @params
          end
          
          it 'should render page url' do
            response.should redirect_to(@page.url)
          end
          
        end
        
      end
      
      context 'cant save response' do
        
        before :each do
          stub(@response).save { false }
          put :update, @params
        end
        
        it 'should raise a form not submitted exception' do
          response.should raise_error
        end
        
      end
      
    end
    
  end
  
end