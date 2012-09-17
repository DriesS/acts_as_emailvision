# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_emailvision}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dries Steenhouwer"]
  s.date = %q{2012-09-17}
  s.description = %q{This gems allow you to create/update members on EMV with the member api}
  s.email = %q{steenhouwer.dries@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "LICENSE.txt",
    "README.md",
    "VERSION",
    "acts_as_emailvision.gemspec",
    "app/controllers/emailvision_controller.rb",
    "lib/acts_as_emailvision.rb",
    "lib/emailvision/acts/emailvision_subscriber.rb",
    "lib/emailvision/api/api.rb",
    "lib/emailvision/api/exception.rb",
    "lib/emailvision/api/logger.rb",
    "lib/emailvision/api/railtie.rb",
    "lib/emailvision/api/relation.rb",
    "lib/emailvision/api/tools.rb",
    "lib/emailvision/base.rb",
    "lib/emailvision/merge_vars.rb",
    "lib/emailvision/railtie.rb",
    "lib/generators/acts_as_emailvision_config/acts_as_emailvision_config_generator.rb",
    "rails/init.rb",
    "tasks/sync_tasks.rake",
    "test/generators/create_user.rb",
    "test/helper.rb",
    "test/models.rb",
    "test/test_acts_as_emailvision.rb"
  ]
  s.homepage = %q{http://github.com/DriesS/acts_as_emailvision}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.1}
  s.summary = %q{Subscribe/Unsubscribe users to EMV list}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, ["~> 0.8.0"])
      s.add_runtime_dependency(%q<crack>, ["~> 0.3.0"])
      s.add_runtime_dependency(%q<builder>, ["~> 3.0.0"])
    else
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<httparty>, ["~> 0.8.0"])
      s.add_dependency(%q<crack>, ["~> 0.3.0"])
      s.add_dependency(%q<builder>, ["~> 3.0.0"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<httparty>, ["~> 0.8.0"])
    s.add_dependency(%q<crack>, ["~> 0.3.0"])
    s.add_dependency(%q<builder>, ["~> 3.0.0"])
  end
end

