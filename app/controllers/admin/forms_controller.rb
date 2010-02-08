class Admin::FormsController < Admin::ResourceController
  skip_before_filter :verify_authenticity_token, :only => :create

  def index
    @forms = Form.search(params[:search], params[:filter], params[:page])
    
    respond_to do |format|
      format.html do 
        render 
      end
      format.js do
        render :partial => 'form.html.haml', :collection => @forms
      end
    end
  end
  
  def new
    @form = Form.new
  end
  
end