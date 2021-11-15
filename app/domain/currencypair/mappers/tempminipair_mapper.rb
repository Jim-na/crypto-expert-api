# frozen_string_literal: false

module CryptoExpert
  module Binance
    # map the Spot Pair info
    class TempMiniPairMapper
      def initialize(token, gateway_class = Binance::Api)
        @token = token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def get(symbol)
        data = {}
        data['symbol'] = symbol
        data['spotpair_klines'] = @gateway.spotpair_klines(symbol)
        TempMiniPairMapper.build_entity(data)
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
          Entity::TempMiniPair.new(
            symbol: symbol,
            time: time,
            volume: spot_volume
          )
        end

        private

        def symbol
          @data['symbol']
        end

        def time
          time = @data['spotpair_klines'][0][0]
        end

        def spot_volume
          @data['spotpair_klines'][0][5].to_f
        end
      end
    end
  end
end
