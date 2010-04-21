# Radiant Forms Extension

This extension allows a developer to create forms which can take on multiple tasks

The idea was taken from the mailer extension, everything mail specific was ripped out and put in
  http://github.com/squaretalent/radiant-forms_mail-extension
  
Using forms 'DRY's up the process of creating and reusing forms across a site (well I think so at least).

## Installation
  
    git clone git://github.com/squaretalent/radiant-forms-extension vendor/extensions/forms
    rake radiant:extensions:forms:migrate
    rake radiant:extensions:forms:update
  
## Usage
  
  A new tab will be present under design, a form has the following properties
    
    title = reference for when you call the form tag (no spaces)
      action = a specification action to submit the form to (posting to external sites etc)
      redirect_to = location to send the redirection to, will go to posting page otherwise
    body = output which will be shown on a radiant page
    content = presentation of data after form is submitted (useful when sending emails)
    config = configuration for form-addons
    
  Include the form in a page using a radius tag
    <r:form name="sexy_form" />
    
## Example

### Body
    
    <ol>
      <li>
        <r:label for='contact[name]'>
          <span class='title'>Your Name</span>
          <r:text name='contact[name] />
        </r:label>
      </li>
      <li>
        <r:label for='contact[email]'>
          <span class='title'>Your Email</span>
          <r:text name='contact[email] />
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
      fields:
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
    
## Forms Addons

  http://github.com/squaretalent/radiant-forms_mail-extension