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
    
    # We need a response object
    @response = find_or_create_response
    # Put the submitted data into the response object
    @response.result = Forms::Config.deep_symbolize_keys(params)
    
    begin
      # Grab the form configuration data
      @form[:config] = Forms::Config.convert(@form.config)
    rescue
      raise "Form '#{@form.title}' has not been configured"
    end
    
    @results =  {}
    # Iterate through each configured extension
    @form[:config].each do |ext, config|
      # New Instance of the FormExtension class
      extension = ("Form#{ext.to_s.capitalize}".constantize).new(@form, @page)
      
      # Result of the extension create method gets merged
      @results.merge!({ ext.to_sym => extension.create }) # merges this extensions results
    end
    # Those results are merged into the response object
    @response.result = @response.result.merge!({ :results => @results})
    
    begin
      @response.save!
      redirect_to (@form.redirect_to.nil? ? @page.url : @form.redirect_to)
    rescue
      "Form '#{@form.name}' could not be submitted."
    end
  end
  
end