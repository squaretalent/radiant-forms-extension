class FormMail
  attr_reader :config, :data
  
  def initialize(form, page)
    @data   = page.data
    @config = form.config[:mail].symbolize_keys
    @body   = page.render_snippet(form)
  end

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
        :content_type   => content_type
      )
      @sent = true
    rescue Exception => exception
      raise exception if RAILS_ENV['development']
      @message = exception
      @sent = false
    end
  end
  
  def from
    from = nil
    unless @config[:field].nil? or !@config[:field][:from].blank?
      from = hash_retrieve(@data, @config[:field][:from])
    else
      from = @config[:from]
    end
    from
  end
  
  def recipients
    to = nil
    unless @config[:field].nil? or !@config[:field][:to].blank?
      to = hash_retrieve(@data, @config[:field][:to])
    else
      to = @config[:to]
    end
    to
  end
  
  def reply_to
    reply_to = nil
    unless @config[:field].nil? or !@config[:field][:reply_to].blank?
      reply_to = hash_retrieve(@data, @config[:field][:reply_to])
    else
      reply_to = @config[:reply_to]
    end
    reply_to
  end
  
  def sender
    sender = nil
    unless @config[:field].nil? or !@config[:field][:sender].blank?
      sender = hash_retrieve(@data, @config[:field][:sender])
    else
      sender = @config[:sender]
    end
    sender
  end
  
  def subject
    subject = nil
    unless @config[:field].nil? or !@config[:field][:subject].blank?
      subject = hash_retrieve(@data, @config[:field][:subject])
    else
      subject = @config[:subject]
    end
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
    content_type = config[:content_type] || 'multipart/mixed'
  end
  
protected
  
  # takes object[value] || value and accesses the hash as hash[object][value] || hash[value]
  def hash_retrieve(hash, array)
    data = array.gsub('[','|').gsub(']','').split('|') rescue nil
    
    result = false
    result = hash.fetch(data[0]) unless data.nil?
    result = result.fetch(data[1]) if !data.nil? and data[1]
  end
  
end