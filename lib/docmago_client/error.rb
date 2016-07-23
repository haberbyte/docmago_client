module DocmagoClient
  module Error
    class NoApiKeyProvidedError < RuntimeError; end
    class NoContentError < ArgumentError; end
    class IntegrityCheckError < RuntimeError; end
  end
end
