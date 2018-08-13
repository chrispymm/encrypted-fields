$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "encrypted_fields/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "encrypted_fields"
  s.version     = EncryptedFields::VERSION
  s.authors     = ["Chris Pymm"]
  s.email       = ["chris.pymm@acts29.com"]
  s.homepage    = "https://...."
  s.summary     = "Adds polymorphic encrypted fields to any ActiveRecord Model"
  s.description = "Implements attr_encrypted as a module to allow multiple columns to be encrypted without adding lots of columns to the model table. Allows for Keys to be rotated for increased security."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec"
  s.add_development_dependency "database_cleaner"

  s.add_dependency "attr_encrypted", "~> 3.1"
end
