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

  s.add_dependency 'typhoeus', '>= 1.0'
  s.add_dependency 'rubyzip', '>= 1.0'
  s.add_dependency 'nokogiri', '~> 1.7'
  s.add_dependency 'addressable', '~> 2.3'

  s.add_development_dependency 'rails', '~> 6.1'
  s.add_development_dependency 'sqlite3', '~> 1.6'
  s.add_development_dependency 'capybara', '~> 2.7'
end
