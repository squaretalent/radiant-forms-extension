class Response < ActiveRecord::Base
  
  def result
    result = {}
    if self.result_json.present?
      result = ActiveSupport::JSON.decode(self.result_json) 
      result = Forms::Config.deep_symbolize_keys(result)
    end
    result
  end
  
  def result=(result)
    self.result_json = ActiveSupport::JSON.encode(result)
  end
  
end