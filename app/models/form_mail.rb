class FormMail
  include Forms::Models::Extension
  
  def create
    @body   = @page.render_snippet(@form)
    
    begin
      FormMailer.deliver_mail(
        :recipients     => recipients,
        :from           => from,
        :reply_to       => reply_to,
        :subject        => subject,
        :body           => body,
        :cc             => cc,
        :headers        => headers,
        :content_type   => content_type,
        :charset        => charset
      )
      @sent = true
    rescue Exception => exception
      raise exception if RAILS_ENV['development']
      @message = exception
      @sent = false
    end
    
    @result = {
      :sent     => self.sent?,
      :message  => self.message,
      :subject  => self.subject,
      :from     => self.from
    }
  end
  
  def from
    from = @config[:from] || "not-set@no.valid.domain.com"
    from = Forms::Tags::Responses.retrieve(@data, @config[:field][:from])  if @config[:field] && !@config[:field][:from].blank?
    from
  end
  
  def recipients
    to = @config[:to] || "not-set@no.valid.domain.com"
    to = Forms::Tags::Responses.retrieve(@data, @config[:field][:to]) if @config[:field] && !@config[:field][:to].blank?
    to
  end
  
  def reply_to
    reply_to = @config[:reply_to]
    reply_to = Forms::Tags::Responses.retrieve(@data, @config[:field][:reply_to]) if @config[:field] && !@config[:field][:reply_to].blank?
    reply_to
  end
  
  def sender
    sender = @config[:sender] || "not-set@no.valid.domain.com"
    sender = Forms::Tags::Responses.retrieve(@data, @config[:field][:sender]) if @config[:field] && !@config[:field][:sender].blank?
    sender
  end
  
  def subject
    subject =  @config[:subject] || "not set"
    subject = Forms::Tags::Responses.retrieve(@data, @config[:field][:subject]) if @config[:field] && !@config[:field][:subject].blank?
    subject
  end
  
  def body
    @body || ''
  end
  
  def cc
    @config[:cc]
  end
  
  def sent?
    @sent || false
  end
  
  def message
    @message || nil
  end
  
  def headers
    headers = { 'Reply-To' => reply_to }
    if sender
      headers['Return-Path'] = sender
      headers['Sender'] = sender
    end
    headers
  end
  
  def content_type
    content_type = @config[:content_type] || 'text/html'
  end
  
  def charset
    charset = @config[:charset] || 'utf-8'
    charset = charset == '' ? nil : charset
  end
  
end