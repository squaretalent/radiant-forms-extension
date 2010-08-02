# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{radiant-forms-extension}
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["dirkkelly"]
  s.date = %q{2010-08-02}
  s.description = %q{Describe your extension here}
  s.email = %q{dirk.kelly@squaretalent.com}
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".gitignore",
     "README.md",
     "Rakefile",
     "VERSION",
     "app/controllers/admin/forms_controller.rb",
     "app/controllers/forms_controller.rb",
     "app/models/form.rb",
     "app/models/form_page.rb",
     "app/models/response.rb",
     "app/views/admin/forms/_fields.html.haml",
     "app/views/admin/forms/_filters.html.haml",
     "app/views/admin/forms/_form.html.haml",
     "app/views/admin/forms/_header.html.haml",
     "app/views/admin/forms/edit.html.haml",
     "app/views/admin/forms/index.html.haml",
     "app/views/admin/forms/new.html.haml",
     "app/views/admin/forms/remove.html.haml",
     "config/locales/en.yml",
     "config/routes.rb",
     "cucumber.yml",
     "db/migrate/001_create_forms.rb",
     "db/migrate/002_create_user_observer.rb",
     "db/migrate/003_rename_output_to_content.rb",
     "db/migrate/004_create_responses.rb",
     "forms_extension.rb",
     "lib/forms/admin_ui.rb",
     "lib/forms/application_controller_extensions.rb",
     "lib/forms/extension_methods.rb",
     "lib/forms/page_extensions.rb",
     "lib/forms/site_controller_extensions.rb",
     "lib/forms/tags.rb",
     "lib/tasks/forms_extension_tasks.rake",
     "public/images/admin/extensions/form/form.png",
     "radiant-forms-extension.gemspec",
     "spec/controllers/forms_controller_spec.rb",
     "spec/datasets/forms.rb",
     "spec/lib/forms/extension_methods_spec.rb",
     "spec/lib/forms/tags_spec.rb",
     "spec/models/form_spec.rb",
     "spec/models/response_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://yourwebsite.com/forms}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Forms Extension for Radiant CMS}
  s.test_files = [
    "spec/controllers/forms_controller_spec.rb",
     "spec/datasets/forms.rb",
     "spec/lib/forms/extension_methods_spec.rb",
     "spec/lib/forms/tags_spec.rb",
     "spec/models/form_spec.rb",
     "spec/models/response_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

