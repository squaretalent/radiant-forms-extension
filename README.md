# Radiant Forms Extension

This extension allows a developer to create forms which can take on multiple tasks

Using forms 'DRY's up the process of creating and reusing forms across a site (well I think so at least).

## Installation

   **The New way:**
    
    gem install radiant-forms-extension
    # add the following line to your config/environment.rb: config.gem 'radiant-forms-extension', :lib => false
    rake radiant:extensions:forms:update
    rake radiant:extensions:forms:migrate

   **The old way:**
    
    git clone git://github.com/squaretalent/radiant-forms-extension vendor/extensions/forms
    rake radiant:extensions:forms:update
    rake radiant:extensions:forms:migrate
    
  
## Usage
  
  A new tab will be present under design, a form has the following properties
    
  * **title** reference for when you call the form tag (no spaces)
    * **action** a specification action to submit the form to (posting to external sites etc)
    * **redirect_to** location to send the redirection to, will go to posting page otherwise
  * **body**  output which will be shown on a radiant page
  * **content** presentation of data after form is submitted (useful when sending emails)
  * **config** configuration for the addons which will use that form
    
  Include the form in a page using a radius tag
    <r:form name="form_title" />
      
## Usage

### Body
    
    <ol>
      <li>
        <r:label for='contact[name]'>
          <span class='title'>Your name</span>
          <r:text name='contact[name]' />
        </r:label>
      </li>
      <li>
        <r:label for='contact[email]'>
          <span class='title'>Your Email</span>
          <r:text name='contact[email]' />
        </r:label>
      </li>
      <li>
        <r:label for='contact[subject]'>
          <span class='title'>Your subject</span>
          <r:text name='contact[subject]' />
        </r:label>
      </li>
      <li>
        <r:label for='contact[message]'>
          <span class='title'>Your message</span>
          <r:text name='contact[message]' />
        </r:label>
      </li>
      <li>
        <r:submit value='Send my message' />
      </li>
    </ol>
    
### Content
    
    <h2>Contact from <r:form:read name='contact[name]' /></h2>

    <p>The message:</p>

    <p><r:form:read name='contact[message]' /></p>

    <p>You can get back to them on <r:form:read name='contact[email]' /></p>
    
    <p>Cheers, <br /> <strong>Cool Mailer</strong></p>
    
### Config
  
  *assuming you have forms_mail installed as well*
    
    mail:
      to: info@company.com
      sender: contact[email]
      field:
        from: contact[email]
        subject: contact[subject]
        reply_to: contact[email]
      
### Response
    
    <html>
      <head>Some Terribly Designed Radiant Page</head>
      <body>
        <r:response>
          
          <h2>Thank you for contacting us <r:get name='contact[name]' /></h2>
          
          <!-- We need to clear the response, sort of like flash data -->
          <r:clear />
          
        </r:response>
      </body>
    </html>
    
### Email

Delete the following line in config/environment.rb

    config.frameworks -= [ :action_mailer ]
    
or just remove the :action_mailer references

    config.frameworks -= []


#### Config

Define your mailing variables 

_hardcoded_

    mail:
      from: email@email.com
      to: email@email.com
      reply_to: email@email.com      
      subject: subject text
      
_variable_
      
    mail:
      field:
        from: person[email]
        to: person[email]
        subject: contact[subject]
        reply_to: person[email]

#### SMTP

Of course you are probably using sendgrid to make sending emails easy, 
but if you're using SMTP create the following to **/config/initializers/form_mail.rb**

    ActionMailer::Base.delivery_method = :smtp
    ActionMailer::Base.raise_delivery_errors = true
    ActionMailer::Base.smtp_settings = {
      :enable_starttls_auto =>  true,
      :address              =>  "smtp.gmail.com",
      :port                 =>  "587",
      :domain               =>  "smtp.gmail.com",
      :authentication       =>  :plain,
      :user_name            =>  "username@gmail.com",
      :password             =>  "password"
    }

## Addons

### The Market

A showcase of how to use addons, allows you to send emails directly from the page

### Model

    class FormBlah
      include Forms::Models::Extension # Sorts out initialization giving you
      
      # def initialize(form, page)
      # @form = form
      # @page = page
      # 
      # @data   = @page.data
      # @config = @form.config[self.class.to_s.downcase.gsub('form', '').to_sym].symbolize_keys # @form.config[:blah]

      def create
        # return = {
        #   :hash => 'these details will be returned to the result page namespaced under blah'  
        # }
      end

    end

  Any form configured with a **blah** block will know to call this controllers create method

    blah:
      key: value
      another: value
      
### Functionality

    I'm going to let you sort that out, you have the create action with input and output
    from here you can decide how your form addon is going to behave.

# Development

    unless ENV["RAILS_ENV"] == "production"
      config.gem 'rspec',             :version => '1.3.0'
      config.gem 'rspec-rails',       :version => '1.3.2'
      config.gem 'cucumber',          :verison => '0.8.5'
      config.gem 'cucumber-rails',    :version => '0.3.2'
      config.gem 'database_cleaner',  :version => '0.4.3'
      config.gem 'ruby-debug',        :version => '0.10.3'
      config.gem 'webrat',            :version => '0.7.1'
      config.gem 'rr',                :version => '0.10.11'
    end

### Mailchimp

    There is a simple mailchimp-addon included. For this you need the hominid-gem installed:

    http://github.com/bgetting/hominid

    Add your API-key and account-details to your Radiant::Config using this convention:

    mailchimp.api_key
    mailchimp.username
    mailchimp.password

    At least, create a subscription-form with a config similar to this one:

    mailchimp:
      action: subscribe
      list_id: 2dxxxx99ac
      field:
        email: contact[email]
        first_name: contact[fname]
        last_name: contact[lname]

    to unsubscribe use this config:

    mailchimp:
      action: unsubscribe
      list_id: 2dxxxx99ac
      field:
        email: contact[email]
