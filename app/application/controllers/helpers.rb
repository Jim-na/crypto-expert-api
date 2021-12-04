# frozen_string_literal: true

module CryptoExpert
    module Request
      # Application value for the path of a requested project
      class MiniPairRequestPath
        def initialize(symbol, request)
          @symbol = symbol
          @request = request
          @path = request.remaining_path
        end
  
        attr_reader :symbol
      end
    end
end
  