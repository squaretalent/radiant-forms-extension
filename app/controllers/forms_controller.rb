class FormsController < ApplicationController

  no_login_required
  
  skip_before_filter :verify_authenticity_token
  
  # POST /forms/1
  #----------------------------------------------------------------------------
  def create
    @page = Page.find(params[:page_id])
    @form = Form.find(params[:form_id])
    @page.data = params    
    
    response = current_response
    response.result = params
    
    begin
      @form[:config] = YAML::load("--- !map:HashWithIndifferentAccess\n"+@form[:config]).symbolize_keys
    rescue
      raise "Form '#{@form.title}' has not been configured"
    end
    
    @form[:config].each do |ext, config|
      ext_controller  = ("Forms#{ext.to_s.capitalize}Controller".constantize).new(@form, @page)
      response.result = response.result.merge({ "#{ext}_ext" => ext_controller.create })
    end
    
    if response.save  
      redirect_to (@form.redirect_to.nil? ? @page.url : @form.redirect_to)
    else
      raise "Form '#{@form.name}' could not be submitted. Sorry"
    end
  end
  
end