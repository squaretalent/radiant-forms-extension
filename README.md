# Radiant Forms Extension

This extension allows a developer to create forms which can take on multiple tasks

The idea was taken from the mailer extension, everything mail specific is used in [radiant-forms_mail-extension](http://github.com/squaretalent/radiant-forms_mail-extension)
  
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
          <span class='title'>Your Name</span>
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
        <r:submit value='Send My Name' />
      </li>
    </ol>
    
### Content
    
    <h2>Contact from <r:get name='contact[name]' /></h2>
    
    <p>You can get back to them on <r:get name='contact[email]' /></p>
    
    <p>Cheers, <br /> <strong>Cool Mailer</strong></p>
    
### Config
  
  *assuming you have forms_mail installed as well*
    
    mail:
      field:
        from: contact[email]
      recipients: info@company.com
      
### Response
    
    <html>
      <head>Some Terribly Designed Radiant Page</head>
      <body>
        <r:forms:response>
          
          <h2>Thank you for contacting us <r:get name='contact[name]' /></h2>
          
          <!-- We need to clear the response, sort of like flash data -->
          <r:clear />
          
        </r:forms:response>
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
      recipients: email@email.com
      from: email@email.com
      sender: email@email.com
      subject: subject text
      
_variable_
      
    mail:
      field:
        from: person[email]
        recipients: person[email]
        reply_to: person[email]
        sender: person[email]
        subject: contact[subject]

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

### Controller

  Must be named **FormsBlahController** and a controller of the same name

    class FormsBlahController
      include Forms::AddonMethods # Manages your controller initialization

      def create
        # @form = Form which the data comes from
        # @page = Page which submitted the form (data contains submitted information)

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