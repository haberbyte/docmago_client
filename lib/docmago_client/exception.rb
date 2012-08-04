module DocmagoClient
  module Exception
    class RequestException < StandardError
      attr_accessor :status_code
      attr_accessor :message
      def initialize(message, status_code)
        self.message     = message
        self.status_code = status_code
        super message
      end

      def to_s
        "#{self.class.name}\nHTTP Status: #{status_code}\nReturned: #{message}"
      end

      def inspect
        self.to_s
      end
    end
    class DocumentCreationFailure < DocmagoClient::Exception::RequestException; end
    class DocumentListingFailure  < DocmagoClient::Exception::RequestException; end
    class DocumentStatusFailure   < DocmagoClient::Exception::RequestException; end
    class DocumentDownloadFailure < DocmagoClient::Exception::RequestException; end
  end
end
