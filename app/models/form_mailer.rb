class FormMailer < ActionMailer::Base
  
  def mail(options)
    content_type  options[:content_type]
    charset       options[:charset]
    headers       options[:headers]
    
    recipients    options[:recipients]
    from          options[:from]
    cc            options[:cc]
    bcc           options[:bcc]
    subject       options[:subject]
    body          options[:body]
  end
  
end