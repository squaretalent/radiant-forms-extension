class FormsController < ApplicationController

  no_login_required
  
  skip_before_filter :verify_authenticity_token

  def new
    @response = find_or_create_response
    @response.update_attribute(:result, nil)
    
    redirect_to :back rescue redirect_to '/'
  end

  def update
    set_page
    set_form
    set_response
    set_configuration
    
    execute_extensions
    
    begin
      @response.save!
      redirect_to @form.redirect_to.present? ? @form.redirect_to : @page.url
    rescue
      "Form '#{@form.title}' could not be submitted."
    end
  end
  
protected

  def set_page
    @page = Page.find(params[:page_id]) rescue Page.first
    @page.data    = params 
    @page.request = OpenStruct.new({
      :referrer => request.referer,
      :session => session # Creating a pretend response object
    })
  end
  
  def set_form
    @form = Form.find(params[:id])
    @form.page = @page
  end
  
  def set_response
    @response = find_or_create_response
    @response.result = Forms::Config.deep_symbolize_keys(params)
  end
  
  def set_configuration
    begin
      # Grab the form configuration data
      @form[:extensions] = Forms::Config.convert(@form.config)
    rescue
      raise "Form '#{@form.title}' has not been configured"
    end
  end
  
  def execute_extensions
    @results =  {}
    # Iterate through each configured extension
    @form[:extensions].each do |name, config|
      result = @form.call_extension(name,config)
      
      @results.merge!({ name.to_sym => result })
      session.merge!(result[:session]) if result[:session].present?
    end
    # Those results are merged into the response object
    @response.result = @response.result.merge!({ :results => @results})
  end
  
end