class Response < ActiveRecord::Base
  
  def result
    ActiveSupport::JSON.decode(self.result_json) unless self.result_json.nil?
  end
  
  def result=(result)
    self.result_json = ActiveSupport::JSON.encode(result)
  end
  
end