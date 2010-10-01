class Form < ActiveRecord::Base
  
  default_scope           :order => 'forms.title ASC'
  
  validates_presence_of   :title
  validates_uniqueness_of :title
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
end