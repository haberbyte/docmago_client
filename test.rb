require 'bundler/setup'

ENV["DOCMAGO_URL"] = "http://localhost:3000/api/"
ENV["DOCMAGO_API_KEY"] = "Hq2zWQ8pfDjbRGZuvJhy"

require 'docmago_client'

puts DocmagoClient.create(:content => "<html></html>")