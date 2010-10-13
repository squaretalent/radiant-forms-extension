class Form < ActiveRecord::Base
  
  attr_accessor :page
  
  default_scope           :order => 'forms.title ASC'
  
  validates_presence_of   :title
  validates_uniqueness_of :title
  
  belongs_to :created_by, :class_name => 'User'
  belongs_to :updated_by, :class_name => 'User'
  
  def call_extension(name,config)
    result = {}
    # Create a class from the config extension
    extension = config[:extension]
    if extension.present?
      klass     = "Form#{extension.to_s.pluralize.classify}".constantize
      # .pluralize.classify means singulars like business and address are converted correctly
      # Create a new instance of that extension
      klass = (klass).new(self, page, config) 
  
      # Result of the extension create method gets merged
      result = klass.create
    else
      raise %{#{self.title}: `#{name}` scenario has not been configured to use an extension.}
    end
  end
  
end