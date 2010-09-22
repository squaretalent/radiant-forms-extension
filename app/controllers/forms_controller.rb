class FormsController < ApplicationController

  no_login_required
  
  skip_before_filter :verify_authenticity_token
  
  # POST /forms/1
  #----------------------------------------------------------------------------
  def create
    @form = Form.find(params[:form_id])
    
    @page = Page.find(params[:page_id])
    @page.data = params 
    @page.request = {
      :session => session
    }
    
    response = current_response
    response.result = params
    
    begin
      @form[:config] = Forms::Config.convert(@form.config)
    rescue Exception => e
      raise e
      raise "Form '#{@form.title}' has not been configured"
    end
    
    @form[:config].each do |ext, config|
      extension = ("Form#{ext.to_s.capitalize}".constantize).new(@form, @page)
      response.result = response.result.merge({ "#{ext}_ext" => extension.create })
    end
    
    if response.save  
      redirect_to (@form.redirect_to.nil? ? @page.url : @form.redirect_to)
    else
      raise "Form '#{@form.name}' could not be submitted. Sorry"
    end
  end
  
end