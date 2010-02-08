class FormController < ApplicationController

  no_login_required
  skip_before_filter :verify_authenticity_token
  
  def create
    @form = Former.new
    @data = params[:form]
    @page = Page.find(params[:page])
    @parts = Form.find(params[:id])
    @parts[:config] = YAML::load("--- !map:HashWithIndifferentAccess\n"+@parts[:config]).symbolize_keys
    
    process_form(@form, @data, @parts)

    redirect_to (@parts.redirect_to.empty? ? @page.url : @parts.redirect_to)
  end
  
private
  
  def process_form(form, data, parts)
    #form.results << 'variable=data'
  end
  
end