require 'digest'
require 'open-uri'
require 'addressable/uri'
require 'nokogiri'
require 'zip'

class URI::Parser
  def split(url)
    a = Addressable::URI.parse url
    [a.scheme, a.userinfo, a.host, a.port, nil, a.path, nil, a.query, a.fragment]
  end
end

module DocmagoClient
  class HTMLResourceArchiver
    def initialize(html, base_path = '.')
      @html = html
      @base_path = base_path
      @doc = Nokogiri::HTML(@html)
    end

    def create_zip(file_path)
      Zip::File.open(file_path, Zip::File::CREATE) do |zipfile|
        zipfile.get_output_stream('document.html') { |f| f.write @html }

        fetch_uris.each do |uri|
          uri = Addressable::URI.parse uri.to_s.strip
          path_digest = Digest::MD5.hexdigest(normalize_uri(uri))

          file_data   = open(uri).read if uri.absolute?
          file_data ||= File.read(resolve_uri(uri)) if File.exist?(resolve_uri(uri))

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
