class Admin::FormsController < Admin::ResourceController

  skip_before_filter :verify_authenticity_token, :only => :create
  
  only_allow_access_to :index, :show, :new, :create, :edit, :update, :remove, :destroy,
    :when => [ :designer, :admin ],
    :denied_url => { :controller => 'admin/pages', :action => 'index' },
    :denied_message => 'You must have designer privileges to perform this action.'
  
end