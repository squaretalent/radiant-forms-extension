class FormMail
  include Forms::Models::Extension
  
  def create
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
        :charset        => charset,
        :config         => @config
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
    from = nil
    unless @config[:field].nil? or !@config[:field][:from].blank?
      from = Forms::Tags::Responses.retrieve(@data, @config[:field][:from])
    else
      from = @config[:from]
    end
    from
  end
  
  def recipients
    to = nil
    unless @config[:field].nil? or !@config[:field][:to].blank?
      to = Forms::Tags::Responses.retrieve(@data, @config[:field][:to])
    else
      to = @config[:to]
    end
    to
  end
  
  def reply_to
    reply_to = nil
    unless @config[:field].nil? or !@config[:field][:reply_to].blank?
      reply_to = Forms::Tags::Responses.retrieve(@data, @config[:field][:reply_to])
    else
      reply_to = @config[:reply_to]
    end
    reply_to
  end
  
  def sender
    sender = nil
    unless @config[:field].nil? or !@config[:field][:sender].blank?
      sender = Forms::Tags::Responses.retrieve(@data, @config[:field][:sender])
    else
      sender = @config[:sender]
    end
    sender
  end
  
  def subject
    subject = nil
    unless @config[:field].nil? or !@config[:field][:subject].blank?
      subject = Forms::Tags::Responses.retrieve(@data, @config[:field][:subject])
    else
      subject = @config[:subject]
    end
    subject
  end
  
  def body
    # This parses the content of the form
    @parser = Radius::Parser.new(PageContext.new(@page), :tag_prefix => 'r')
    if @config[:body]
      @body = @parser.parse(@form.send(@config[:body]))
    else
      @body = @parser.parse(@form.content)
    end
    @body
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