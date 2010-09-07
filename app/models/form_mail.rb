class FormMail
  attr_reader :config, :data
  
  def initialize(form, page)
    @data   = page.data
    @config = form.config[:mail]
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
        :content_type   => content_type,
        :charset        => charset,
        :files          => files,
        :filesize_limit => filesize_limit
      )
      @sent = true
    rescue Exception => exception
      @message = exception
      @sent = false
    end
  end
  
  def from
    hash_retrieve(@data, @config[:field]['from']) || @config[:from]
  end
  
  def recipients
    hash_retrieve(@data, @config[:field]['recipients']) || @config[:recipients]
  end
  
  def reply_to
    hash_retrieve(@data, @config[:field]['reply_to']) || from
  end
  
  def sender
    hash_retrieve(@data, @config[:field]['sender']) || @config[:sender]
  end
  
  def subject
    hash_retrieve(@data, @config[:field]['subject']) || @config[:subject]
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
  
  def files
    res = []
    data.each_value do |d|
      res << d if StringIO === d or Tempfile === d
    end
    res
  end
  
  def filesize_limit
    config[:filesize_limit] || nil
  end
  
  def headers
    headers = { 'Reply-To' => reply_to }
    if sender
      headers['Return-Path'] = sender
      headers['Sender'] = sender
    end
  end
  
  def content_type
    content_type = config[:content_type] || 'multipart/mixed'
  end
  
  def charset
    charset = config[:charset] || 'utf-8'
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