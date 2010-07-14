class FormController < ApplicationController

  no_login_required
  skip_before_filter :verify_authenticity_token
  
  # POST /forms/1
  #----------------------------------------------------------------------------
  def create
    @page = Page.find(params[:page])
    @form = Form.find(params[:id])
    @page.data = @data = params
    @response = current_response
    @response.result = {}
    
    begin
      @form[:config] = YAML::load("--- !map:HashWithIndifferentAccess\n"+@form[:config]).symbolize_keys
    rescue
      raise "Form '#{@form.name}' has not been configured"
    end
    
    @form[:config].each do |ext, config|
      e = ("Form#{ext.to_s.capitalize}Controller".constantize).new(@form, @data, @page)
      @response.result[ext.to_sym] = e.create
    end
    
    if @response.save  
      redirect_to (@form.redirect_to.empty? ? @page.url : @form.redirect_to)
    else
      raise "Form '#{@form.name}' could not be submitted. Sorry"
    end
  end
  
end