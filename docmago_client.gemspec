$:.push File.expand_path('../lib', __FILE__)

require 'docmago_client/version'

Gem::Specification.new do |s|
  s.name        = 'docmago_client'
  s.version     = DocmagoClient::VERSION
  s.authors     = ['Jan Habermann']
  s.email       = ['jan@habermann24.com']
  s.license     = 'MIT'
  s.homepage    = 'http://github.com/docmago/docmago_client'
  s.summary     = 'Client for the Docmago API (www.docmago.com)'
  s.description = 'Makes it easy to create PDF documents through the Docmago API.'
  s.files       = Dir['README.md', 'LICENSE', 'lib/**/*.rb']

  # TODO: use rest-client gem
  s.add_dependency 'httparty', '>= 0.13.0'
  s.add_dependency 'httmultiparty', '>= 0.3.10'
  s.add_dependency 'nokogiri', '~> 1.6'
  s.add_dependency 'rubyzip', '~> 1.1'
  s.add_dependency 'addressable', '~> 2.3'

  s.add_development_dependency 'rails', '~> 4.1'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'capybara', '~> 2.4'
end
