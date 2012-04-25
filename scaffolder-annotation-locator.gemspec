# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "scaffolder-annotation-locator"
  s.version     = "0.1.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Barton"]
  s.email       = "mail@next.gs"
  s.homepage    = "http://next.gs"
  s.licenses    = ["MIT"]
  s.summary     = "Update locations of gff3 annotations from a scaffolder template"
  s.description = "Build a genome scaffold using scaffolder and a set of annotated contigs. This tool updates the locations of the contig annotations using the scaffold template as a base."

  s.rubyforge_project         = "scaffolder-annotation-locator"
  s.required_rubygems_version = ">= 1.8.0"

  s.require_path     = 'lib'
  s.files            = `git ls-files`.split("\n")
  s.extra_rdoc_files = %w| LICENSE.txt README.rdoc |

  s.add_dependency "scaffolder", ">= 0.4.3"
  s.add_dependency "bio",        "~> 1.4.0"

  s.add_development_dependency "rake",                    "~> 0.9.0"
  s.add_development_dependency "bundler",                 "~> 1.1.0"
  s.add_development_dependency "rspec",                   "~> 2.7.0"
  s.add_development_dependency "cucumber",                "~> 1.1.4"
  s.add_development_dependency "aruba",                   "~> 0.4.11"
  s.add_development_dependency "scaffolder-test-helpers", "~> 0.4.0"
  s.add_development_dependency "yard",                    "~> 0.6.0"
end
