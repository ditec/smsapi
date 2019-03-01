$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sms"
  s.version     = Sms::VERSION
  s.authors     = ["me"]
  s.email       = ["me@a.com"]
  s.summary     = "Summary of Sms."
  s.description = "Description of Sms."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = ">= 2.4"

  s.add_dependency "jquery-rails"
  s.add_dependency "validates_timeliness", '~> 5.0.0.alpha3'

  s.add_development_dependency "rails", "~> 5.1.4"
  s.add_development_dependency "mysql2", "~> 0.4.9"
end
