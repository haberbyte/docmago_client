require 'digest'
require 'open-uri'
require 'addressable/uri'
require 'nokogiri'
require 'zip'

module DocmagoClient
  class HTMLResourceArchiver
    SPROCKETS_RX = %r{^/assets/}
    URI_RX = /url\(("([^"]*)"|'([^']*)'|([^)]*))\)/im

    def initialize(options = {})
      @html = options[:content]
      @base_path = options[:resource_path]
      @assets = options[:assets]

      @doc = Nokogiri::HTML(@html)
    end

    def create_zip(file_path)
      Zip::File.open(file_path, Zip::File::CREATE) do |zipfile|
        zipfile.get_output_stream('document.html') { |f| f.write @html }

        fetch_uris.each do |uri|
          uri = Addressable::URI.parse uri.to_s.strip
          path_digest = Digest::MD5.hexdigest(uri.to_s)

          file_data = open(uri).read if uri.absolute?
          file_data ||= File.read(resolve_uri(uri)) if File.exist?(resolve_uri(uri))
          file_data ||= @assets[normalize_uri(uri).gsub(SPROCKETS_RX, '')].to_s

          if File.extname(normalize_uri(uri)) == '.css'
            # embed resources within css
            file_data.scan(URI_RX).flatten.compact.uniq.each do |resource|
              resource_uri = Addressable::URI.parse resource.to_s.strip
              resource_path_digest = Digest::MD5.hexdigest(resource_uri.to_s)

              resource_file = open(resource_uri).read if resource_uri.absolute?
              resource_file = File.read(resolve_uri(resource_uri)) if File.exist?(resolve_uri(resource_uri))
              resource_file ||= @assets[normalize_uri(resource_uri).gsub(SPROCKETS_RX, '')].to_s

              zipfile.get_output_stream(resource_path_digest) { |f| f.write resource_file } if resource_file
            end
          end

          zipfile.get_output_stream(path_digest) { |f| f.write file_data } if file_data
        end
      end

      file_path
    end

    private

    def fetch_uris
      @doc.xpath("//link[@rel='stylesheet']/@href", '//img/@src')
    end

    def normalize_uri(uri)
      uri = Addressable::URI.parse uri.to_s.strip
      uri.query = nil
      uri.to_s
    end

    def resolve_uri(uri)
      File.join File.expand_path(@base_path), normalize_uri(uri)
    end
  end
end
