module Forms
  module ExtensionMethods
    def self.included(base)
      attr_accessor :form, :page, :data
      base.class_eval do 
        def initialize(form, page)
          @form = form
          @data = page.data
          @page = page
        end
      end
    end
  end
end