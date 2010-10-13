module Forms
  module Models
    module Page

      def self.included(base)
        base.class_eval do
          attr_accessor :last_form
          attr_accessor :data
          attr_accessor :environment
        end
      end

    end
  end
end
