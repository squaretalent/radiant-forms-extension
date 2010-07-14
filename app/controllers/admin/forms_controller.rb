class Admin::FormsController < Admin::ResourceController

  skip_before_filter :verify_authenticity_token, :only => :create
  
  only_allow_access_to :index, :show, :new, :create, :edit, :update, :remove, :destroy,
    :when => [ :designer, :admin ],
    :denied_url => { :controller => 'admin/pages', :action => 'index' },
    :denied_message => 'You must have designer privileges to perform this action.'

  # GET /admin/forms
  # GET /admin/forms.js
  #----------------------------------------------------------------------------
  def index
    @forms = Form.search(params[:search], params[:filter], params[:page])
    
    respond_to do |format|
      format.html { render }
      format.js { render :partial => 'form.html.haml', :collection => @forms }
    end
  end
  
  # GET /admin/forms/new
  #----------------------------------------------------------------------------
  def new
    @form = Form.new
    
    respond_to do |format|
      format.html { render }
    end
  end
  
end