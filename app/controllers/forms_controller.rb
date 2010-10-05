class FormsController < ApplicationController

  no_login_required
  
  skip_before_filter :verify_authenticity_token

  def update
    @form = Form.find(params[:id])
    
    @page = Page.find(params[:page_id]) rescue Page.first
    @page.data    = params 
    @page.request = OpenStruct.new({
      :session => session # Creating a pretend response object
    })
    
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
    @form[:extensions].each do |ext, config|
      # New Instance of the FormExtension class
      extension = ("Form#{ext.to_s.pluralize.classify}".constantize).new(@form, @page) 
      # .pluralize.classify means singulars like business and address are converted correctly
      
      # Result of the extension create method gets merged
      result = extension.create
      
      @results.merge!({ ext.to_sym => result }) # merges this extensions results
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