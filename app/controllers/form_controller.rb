class FormController < ApplicationController

  no_login_required
  skip_before_filter :verify_authenticity_token
  
  def create
    @page = Page.find(params[:page])
    @form = Form.find(params[:id])
    @page.data = @data = params
    @response = current_response
    @response.result = {}
    
    begin
      @form[:config] = YAML::load("--- !map:HashWithIndifferentAccess\n"+@form[:config]).symbolize_keys
    rescue
      raise "Form not configured"
    end
    
    process_form(@form, @data, @page, @response)

    @response.save
    
    redirect_to (@form.redirect_to.empty? ? @page.url : @form.redirect_to)
  end
  
private
  
  def process_form(form, data, page, response)
    # { :extension => { :result => true } }
  end
  
end