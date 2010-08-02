# Radiant Forms Extension

This extension allows a developer to create forms which can take on multiple tasks

The idea was taken from the mailer extension, everything mail specific is used in [radiant-forms_mail-extension](http://github.com/squaretalent/radiant-forms_mail-extension)
  
Using forms 'DRY's up the process of creating and reusing forms across a site (well I think so at least).

## Installation
  
    git clone git://github.com/squaretalent/radiant-forms-extension vendor/extensions/forms
    rake radiant:extensions:forms:migrate
    rake radiant:extensions:forms:update
  
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
    
## Addons

### The Market

* [radiant-forms_mail-extension](http://github.com/squaretalent/radiant-forms_mail-extension) - 
A showcase of how to use addons, allows you to send emails directly from the page

### Controller

  Must be named **FormsBlahController** and contain an inherited FormsExtensionController of the same name

    class FormsBlahController < FormsExtensionController

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