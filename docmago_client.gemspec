$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "docmago_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "docmago_client"
  s.version     = DocmagoClient::VERSION
  s.authors     = ["Jan Habermann"]
  s.email       = ["jan@habermann24.com"]
  s.homepage    = "www.docmago.com"
  s.summary     = "TODO: Summary of DocmagoClient."
  s.description = "TODO: Description of DocmagoClient."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  
  s.add_dependency "httparty", ">=0.7.0"
  
  s.add_development_dependency "rails", "~> 3.2.5"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "capybara"
end
