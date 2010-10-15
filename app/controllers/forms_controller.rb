class FormsController < ApplicationController

  no_login_required
  
  skip_before_filter :verify_authenticity_token

  def update
    @page = Page.find(params[:page_id]) rescue Page.first
    @page.data    = params 
    @page.request = OpenStruct.new({
      :session => session # Creating a pretend response object
    })
    
    @form = Form.find(params[:id])
    @form.page = @page
    
    # We need a response object
    @response = find_or_create_response
    # Put the submitted data into the response object
    @response.result = Forms::Config.deep_symbolize_keys(params)
    
    begin
      # Grab the form configuration data
      @form[:extensions] = Forms::Config.convert(@form.config)
    rescue
      raise "Form '#{@form.title}' has not been configured"
    end
    
    @results =  {}
    # Iterate through each configured extension
    @form[:extensions].each do |name, config|
      result = @form.call_extension(name,config)
      
      @results.merge!({ config[:extension].to_sym => result })
      session.merge!(result[:session]) if result[:session].present?
    end
    # Those results are merged into the response object
    @response.result = @response.result.merge!({ :results => @results})
    
    begin
      @response.save!
      redirect_to @form.redirect_to.present? ? @form.redirect_to : @page.url
    rescue
      "Form '#{@form.title}' could not be submitted."
    end
  end
  
end