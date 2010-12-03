# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scaffolder-annotation-locator}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Barton"]
  s.date = %q{2010-12-03}
  s.description = %q{TODO: longer description of your gem}
  s.email = %q{mail@michaelbarton.me.uk}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "features/scaffolder-annotation-locator.feature",
    "features/step_definitions/scaffolder-annotation-locator_steps.rb",
    "features/support/env.rb",
    "lib/scaffolder-annotation-locator.rb",
    "spec/scaffolder-annotation-locator_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/michaelbarton/scaffolder-annotation-locator}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{TODO: one-line summary of your gem}
  s.test_files = [
    "spec/scaffolder-annotation-locator_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5"])
      s.add_development_dependency(%q<rspec>, ["~> 2.2"])
      s.add_development_dependency(%q<cucumber>, ["~> 0.9"])
      s.add_development_dependency(%q<yard>, ["~> 0.6"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5"])
      s.add_dependency(%q<rspec>, ["~> 2.2"])
      s.add_dependency(%q<cucumber>, ["~> 0.9"])
      s.add_dependency(%q<yard>, ["~> 0.6"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5"])
    s.add_dependency(%q<rspec>, ["~> 2.2"])
    s.add_dependency(%q<cucumber>, ["~> 0.9"])
    s.add_dependency(%q<yard>, ["~> 0.6"])
  end
end

