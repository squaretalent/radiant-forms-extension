module Forms
  module Models
    module Page

      def self.included(base)
        base.class_eval do
          attr_accessor :last_form
          attr_accessor :data
        end
      end
      
    end
  end
end