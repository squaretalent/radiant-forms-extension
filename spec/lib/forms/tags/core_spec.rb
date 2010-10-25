require 'spec/spec_helper'

describe Forms::Tags::Core do
  
  dataset :pages, :forms
  
  context 'contained tags' do
  
    it 'should describe these tags' do
      Forms::Tags::Core.tags.sort.should == [
        'form',
        'form:label',
        'form:text',
        'form:password',
        'form:reset',
        'form:checkbox',
        'form:radio',
        'form:hidden',
        'form:file',
        'form:button',
        'form:select',
        'form:radios',
        'form:option',
        'form:submit',
        'form:read',
        'form:read:each',
        
        'response',
        'response:clear',
        'response:get',
        'response:if_results', 
        'response:unless_results',
        'response:if_get', 
        'response:unless_get',  
        
        'index',
        'reset'    
      ].sort
    end
    
  end
  
  context 'form output' do
    
    before :all do
      @form = forms(:test)
      @page = pages(:home)
    end
    
    describe '<r:form>' do
      it 'should render the correct HTML' do
        tag = %{<r:form name="#{@form.title}" />}

        expected = %{<form enctype="multipart/form-data" method="post" name="#{@form.title}" action="/forms/#{@form.id}" id="form_test_form">
<input type="hidden" name="_method" value="put" />
<input type="hidden" name="page_id" value="#{@page.id}" />
<input type="text" value="" name="request[test]" class="text" id="request_test" /></form>}
       @page.should render(tag).as(expected)
      end
    end
    
    describe '<r:form:label>' do
      
      it 'should render the correct HTML' do
        tag = %{<r:form:label for="test[field]">text</r:form:label>}
        expected = %{<label id="test_field_label" for="test_field">text</label>}
        @page.should render(tag).as(expected)
      end
      
      it 'should require the name attribute' do
        tag = %{<r:form:label />}
        @page.should_not render(tag)
      end
      
    end

    %w(text password reset checkbox radio hidden file button).each do |type|

      describe "<r:form:#{type}>" do      
        
        it 'should render the correct HTML' do
          tag = %{<r:form:#{type} name="test[field]">text</r:form:#{type}>}
          expected = %{<input type="#{type}" value="" name="test[field]" class="#{type}" id="test_field" />}
          @page.should render(tag).as(expected)
        end
        
        it 'should require the name attribute' do
          tag = %{<r:form:#{type} />}
          @page.should_not render(tag)
        end
        
      end
      
    end
    
    describe '<r:form:select>' do
      
      it 'should render the correct HTML' do
        tag = %{<r:form:select name="test[field]" />}
        expected = %{<select name="test[field]" id="test_field"></select>}
        @page.should render(tag).as(expected)
      end
      
      it 'should render correct options HTML' do
        tag = %{<r:form:select name="test[field]"><r:option value="one" /><r:option value="two">three</r:option></r:form:select>}
        expected = %{<select name="test[field]" id="test_field"><option value="one">one</option><option value="two">three</option></select>}
        @page.should render(tag).as(expected)
      end
      
      it 'should require the name attribute' do
        tag = %{<r:form:select />}
        @page.should_not render(tag)
      end
      
    end
    
    describe '<r:form:radios>' do
      
      it 'should render the correct HTML' do
        tag = %{<r:form:radios name="test[field]" />}
        expected = %{}
        @page.should render(tag).as(expected)
      end
      
      it 'should render correct options HTML' do
        tag = %{<r:form:radios name="test[field]"><r:option value="one" /><r:option value="two" /></r:form:radios>}
        expected = %{<input name="test[field]" id="test_field_one" type="radio" value="one" /><input name="test[field]" id="test_field_two" type="radio" value="two" />}
        @page.should render(tag).as(expected)
      end
      
      it 'should require the name attribute' do
        tag = %{<r:form:radios />}
        @page.should_not render(tag)
      end
      
    end
    
    describe '<r:form:submit>' do
      
      it 'should render the correct HTML' do
        
      end
      
    end
    
  end
  
  context 'response' do
    
    context 'conditionals' do

      before :each do
        @page = pages(:home)
        mock_response
      end

      describe 'if_results' do
        context 'extension sent results' do
          it 'should render' do
            @response.result[:results] = { :bogus => { :payment => true } }

            tag = %{<r:response:if_results extension='bogus'>success</r:response:if_results>}
            exp = %{success}
            @page.should render(tag).as(exp)
          end
        end
        context 'extension did not send results' do
          it 'should not render' do
            tag = %{<r:response:if_results extension='bogus'>failure</r:response:if_results>}
            exp = %{}
            @page.should render(tag).as(exp)
          end
        end
      end

      describe 'unless_results' do
        context 'extension did not send results' do
          it 'should render' do
            tag = %{<r:response:unless_results extension='bogus'>success</r:response:unless_results>}
            exp = %{success}
            @page.should render(tag).as(exp)
          end
        end
        context 'extension sent results' do
          it 'should not render' do
            @response.result[:results] = { :bogus => { :payment => true } }

            tag = %{<r:response:unless_results extension='bogus'>failure</r:response:unless_results>}
            exp = %{}
            @page.should render(tag).as(exp)
          end
        end
      end

      describe 'if_get' do
        context 'extension sent positive results' do
          it 'should render' do
            @response.result[:results] = { :bogus => { :payment => true } }

            tag = %{<r:response:if_results extension='bogus'><r:if_get name='payment'>success</r:if_get></r:response:if_results>}
            exp = %{success}
            @page.should render(tag).as(exp)
          end
        end
        context 'extension sent negative results' do
          it 'should not render' do
            @response.result[:results] = { :bogus => { :payment => false } }

            tag = %{<r:response:if_results extension='bogus'><r:if_get name='payment'>failure</r:if_get></r:response:if_results>}
            exp = %{}
            @page.should render(tag).as(exp)
          end
        end
      end

      describe 'unless_get' do
        context 'extension sent positive results' do
          it 'should render' do
            @response.result[:results] = { :bogus => { :payment => false } }

            tag = %{<r:response:if_results extension='bogus'><r:unless_get name='payment'>success</r:unless_get></r:response:if_results>}
            exp = %{success}
            @page.should render(tag).as(exp)
          end
        end
        context 'extension sent negative results' do
          it 'should not render' do
            @response.result[:results] = { :bogus => { :payment => true } }

            tag = %{<r:response:if_results extension='bogus'><r:unless_get name='payment'>failure</r:unless_get></r:response:if_results>}
            exp = %{}
            @page.should render(tag).as(exp)
          end
        end
      end

    end
    
  end
  
end