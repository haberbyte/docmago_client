require 'typhoeus'
require 'tempfile'

require 'docmago_client/version'
require 'docmago_client/exception'
require 'docmago_client/error'
require 'docmago_client/html_resource_archiver'

if defined?(Rails)
  if Rails.respond_to?(:version) && Rails.version =~ /^(3|4)/
    require 'docmago_client/railtie'
  else
    raise "docmago_client #{DocmagoClient::VERSION} is only compatible with Rails 3 or 4"
  end
end

module DocmagoClient
  class << self
    attr_accessor :base_uri, :api_key
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout)
    end

    def base_uri
      @base_uri || ENV['DOCMAGO_URL'] || 'https://docmago.com/api'
    end

    def api_key
      @api_key || ENV['DOCMAGO_API_KEY']
    end
  end

  # when given a block, hands the block a TempFile of the resulting document
  # otherwise, just returns the response
  def self.create(options = {})
    raise ArgumentError, 'please pass in an options hash' unless options.is_a? Hash
    if options[:content].nil? || options[:content].empty?
      raise DocmagoClient::Error::NoContentError.new, 'must supply :content'
    end

    default_options = {
      name: 'default',
      type: 'pdf'
    }

    options = default_options.merge(options)

    if options[:zip_resources]
      tmp_dir = Dir.mktmpdir
      begin
        resource_archiver = HTMLResourceArchiver.new(options)
        options[:content] = File.new(resource_archiver.create_zip("#{tmp_dir}/document.zip"))
        options.delete :assets

        response = Typhoeus.post "#{base_uri}/documents", body: {
          auth_token: api_key,
          document: options.slice(:content, :name, :type, :test_mode)
        }
      ensure
        FileUtils.remove_entry_secure tmp_dir
      end
    else
      response = Typhoeus.post "#{base_uri}/documents", body: {
        auth_token: api_key,
        document: options.slice(:content, :name, :type, :test_mode)
      }
    end

    if block_given?
      ret_val = nil
      Tempfile.open('docmago') do |f|
        f.sync = true
        f.write(response.body.force_encoding('utf-8'))
        f.rewind

        ret_val = yield f, response
      end
      ret_val
    else
      response
    end
  end
end
