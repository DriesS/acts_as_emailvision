# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = ActsAsEmailvision
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.date = %q{2013-02-11}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".rspec",
    "LICENSE.txt",
    "README.md",
    "VERSION",
    "acts_as_emailvision.gemspec",
    "app/controllers/emailvision_controller.rb",
    "lib/acts_as_emailvision.rb",
    "lib/acts_as_emailvision/acts/emailvision_subscriber.rb",
    "lib/acts_as_emailvision/base.rb",
    "lib/acts_as_emailvision/merge_vars.rb",
    "lib/acts_as_emailvision/railtie.rb",
    "lib/generators/acts_as_emailvision_config/acts_as_emailvision_config_generator.rb",
    "rails/init.rb",
    "spec/acts_as_emailvision_test.rb",
    "spec/dummy/README.rdoc",
    "spec/dummy/app/assets/javascripts/application.js",
    "spec/dummy/app/assets/stylesheets/application.css",
    "spec/dummy/app/controllers/application_controller.rb",
    "spec/dummy/app/helpers/application_helper.rb",
    "spec/dummy/app/mailers/.gitkeep",
    "spec/dummy/app/models/.gitkeep",
    "spec/dummy/app/models/user.rb",
    "spec/dummy/app/views/layouts/application.html.erb",
    "spec/dummy/config.ru",
    "spec/dummy/config/application.rb",
    "spec/dummy/config/boot.rb",
    "spec/dummy/config/database.yml",
    "spec/dummy/config/emailvision.yml",
    "spec/dummy/config/environment.rb",
    "spec/dummy/config/environments/development.rb",
    "spec/dummy/config/environments/production.rb",
    "spec/dummy/config/environments/test.rb",
    "spec/dummy/config/initializers/backtrace_silencers.rb",
    "spec/dummy/config/initializers/inflections.rb",
    "spec/dummy/config/initializers/mime_types.rb",
    "spec/dummy/config/initializers/secret_token.rb",
    "spec/dummy/config/initializers/session_store.rb",
    "spec/dummy/config/initializers/wrap_parameters.rb",
    "spec/dummy/config/locales/en.yml",
    "spec/dummy/config/routes.rb",
    "spec/dummy/db/development.sqlite3",
    "spec/dummy/db/migrate/20130211112150_add_users.rb",
    "spec/dummy/db/test.sqlite3",
    "spec/dummy/lib/assets/.gitkeep",
    "spec/dummy/log/.gitkeep",
    "spec/dummy/log/development.log",
    "spec/dummy/log/test.log",
    "spec/dummy/public/404.html",
    "spec/dummy/public/422.html",
    "spec/dummy/public/500.html",
    "spec/dummy/public/favicon.ico",
    "spec/dummy/script/rails",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "tasks/sync_tasks.rake",
    "test_file"
  ]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.1}
  s.summary = nil

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<emailvision>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<emailvision>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<emailvision>, [">= 0"])
  end
end

