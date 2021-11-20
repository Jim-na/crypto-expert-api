# frozen_string_literal: false

module CryptoExpert
  module Binance
    # map the Spot Pair info
    class MiniPairMapper
      def initialize(symbol)
        @symbol = symbol
        @now = CryptoExpert::Binance::TempMiniPairMapper.new(CryptoExpert::App.config.BINANCE_API_KEY).get(symbol)
        @history = CryptoExpert::Repository::TempMiniPairs.find_symbol(symbol)
      end

      def get
        data = {}
        data['symbol'] = @symbol
        data['now'] = @now
        data['history'] = @history
        MiniPairMapper.build_entity(data)
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
          Entity::MiniPair.new(
            symbol: symbol,
            increase_percent: increase_percent
          )
        end

        private

        def symbol
          @data['symbol']
        end

        def increase_percent
          if @data['history'].nil?
            0.0
          else
            (@data['now'].volume - @data['history'].volume) / @data['history'].volume
          end
        end
      end
    end
  end
end
