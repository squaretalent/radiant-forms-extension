# Extend FormExtensionController so that the initializer creates the 
# default instance variables of @form, @data, and @page

class FormMailsController < FormsExtensionController
  
  # Called by FormController only if @form[:config] contains mail:
  #----------------------------------------------------------------------------
  def create
    mail = FormMail.new(@form, @page)
    mail.create
    
    result = {
      :sent     => mail.sent?,
      :message  => mail.message,
      :subject  => mail.subject,
      :from     => mail.from
    }
  end
    
end