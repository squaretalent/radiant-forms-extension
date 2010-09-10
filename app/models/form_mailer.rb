class FormMailer < ActionMailer::Base
  
  def mail(options)
    recipients    options[:recipients]
    from          options[:from]
    cc            options[:cc]
    bcc           options[:bcc]
    subject       options[:subject]
    headers       options[:headers]
    part          :content_type => options[:content_type], :body => options[:body]
  end
  
end