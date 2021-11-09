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
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
          @exchange = 'Binance'
        end

        def build_entity
          Entity::SpotPair.new(
            symbol: symbol,
            price: price,
            exchange: exchange
          )
        end

        private

        def symbol
          @data['symbol']
        end

        def price
          @data['price'].to_f
        end

        attr_reader :exchange
      end
    end
  end
end
