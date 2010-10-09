class FormMailchimp
  include Forms::Models::Extension
  
  def create
    @body   = @page.render_snippet(@form)

    begin
      h = Hominid::Base.new({ :api_key => Radiant::Config['mailchimp.api_key'],
                            :username => Radiant::Config['mailchimp.username'],
                            :password => Radiant::Config['mailchimp.password'],
                            :send_goodbye => false,
                            :send_notify => true,
                            :double_opt => false})
      if action == "subscribe"
        h.subscribe(list_id, email, {:FNAME => fname, :LNAME => lname}, {:email_type => 'html', :send_welcome => true, :double_optin => false})
      end
      if action == "unsubscribe"
        h.unsubscribe(list_id, email, {:delete_member => false, :send_goodbye => true, :send_notify => false})
      end

      @sent = true
    rescue Exception => exception
      raise exception if RAILS_ENV['development']
      @message = exception
      @sent = false
    end
    
    @result = {
      :sent     => self.sent?,
      :message  => self.message,
      :action   => self.action,
      :email    => self.email
    }
  end

  def list_id
    list_id = @config[:list_id] || "0"
    list_id
  end

  def action
    action = @config[:action] || "subscribe"
    action
  end

  def email
    email = @config[:email] || "not-set@no.valid.domain.com"
    email = Forms::Tags::Responses.retrieve(@data, @config[:field][:email]) if @config[:field] && !@config[:field][:email].blank?
    email
  end

  def fname
    fname = Forms::Tags::Responses.retrieve(@data, @config[:field][:first_name])  if @config[:field] && !@config[:field][:first_name].blank?
    fname
  end
  
  def lname
    lname = Forms::Tags::Responses.retrieve(@data, @config[:field][:last_name])  if @config[:field] && !@config[:field][:last_name].blank?
    lname
  end
  
  def reply_to
    reply_to = @config[:reply_to]
    reply_to = Forms::Tags::Responses.retrieve(@data, @config[:field][:reply_to]) if @config[:field] && !@config[:field][:reply_to].blank?
    reply_to
  end
  
  def subject
    subject =  @config[:subject] || "not set"
    subject = Forms::Tags::Responses.retrieve(@data, @config[:field][:subject]) if @config[:field] && !@config[:field][:subject].blank?
    subject
  end
 
  def sent?
    @sent || false
  end
  
  def message
    @message || nil
  end
  
end