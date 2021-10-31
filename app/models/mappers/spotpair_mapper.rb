# frozen_string_literal: false

module CryptoExpert
  module Binance
    # map the Spot Pair info
    class SpotPairMapper
      def initialize(token, gateway_class = Binance::Api)
        @token = token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def get(symbol_list)
        data = @gateway.spotpair(symbol_list)
        SpotPairMapper.build_entity(data)
        # symbol_list.map do |symbol|
        #   data = @gateway.spotpair(symbol)
        #   SpotPairMapper.build_entity(data)
        # end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::SpotPair.new(
            symbol: symbol,
            price: price
          )
        end

        private

        def symbol
          @data['symbol']
        end

        def price
          @data['price']
        end
      end
    end
  end
end
