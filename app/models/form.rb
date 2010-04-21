class Form < ActiveRecord::Base
  
  validates_presence_of :title
  
  class << self
    def search(search, filter, page)
      unless search.blank?
        
        search_cond_sql = []
        search_cond_sql << 'LOWER(title) LIKE (:term)'
        
        cond_sql = search_cond_sql.join(" or ")
        
        @conditions = [cond_sql, {:term => "%#{search.downcase}%" }]
      else
        @conditions = []
      end
      
      options = { :conditions => @conditions,
                  :order => 'title ASC',
                  :page => page,
                  :per_page => 10 }
      
      Form.paginate(:all, options)
    end
  end
  
end