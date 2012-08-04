module DocmagoClient
  module Error
    class NoApiKeyProvidedError < RuntimeError; end
    class NoContentError        < ArgumentError; end
  end
end
