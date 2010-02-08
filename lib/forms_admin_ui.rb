module FormsAdminUI

 def self.included(base)
   base.class_eval do

      attr_accessor :form
      alias_method :forms, :form
      
      protected

        def load_default_form_regions
          returning OpenStruct.new do |form|
            form.edit = Radiant::AdminUI::RegionSet.new do |edit|
              edit.main.concat %w{edit_header edit_form}
              edit.form.concat %w{edit_title edit_content}
              edit.form_bottom.concat %w{edit_buttons edit_timestamp}
            end
            form.new = form.edit
          end
        end
      
    end
  end
end

