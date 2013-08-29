require 'uri'
require 'nokogiri'
require 'zip'

module DocmagoClient
  class HTMLResourceArchiver
    def initialize(html, base_path='.')
      @html = html
      @base_path = base_path
      @doc = Nokogiri::HTML(@html)
    end
  
    def create_zip(file_path)
      Zip::File.open(file_path, Zip::File::CREATE) do |zipfile|
        zipfile.get_output_stream("document.html") { |f| f.write @html }
      
        fetch_uris.each do |uri|
          if File.exists?(resolve_uri(uri))
            zipfile.get_output_steam(normalize_uri(uri)) { |f| f.write(File.read(resolve_uri(uri))) }
          end
        end
      end
    
      return file_path
    end
  
    private
      def fetch_uris
        @doc.xpath("//link[@rel='stylesheet']/@href", "//img/@src")
      end
      
      def normalize_uri(uri)
        uri = URI.parse URI.encode(uri.to_s.strip)
        uri.query = nil
        uri.to_s
      end
  
      def resolve_uri(uri)      
        File.join File.expand_path(@base_path), normalize_uri(uri)
      end
  end
end