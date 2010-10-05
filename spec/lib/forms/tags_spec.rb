require File.dirname(__FILE__) + '/../../spec_helper'

describe Forms::Tags do
  dataset :pages, :forms
  
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
  
end