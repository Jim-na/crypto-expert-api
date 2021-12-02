# frozen_string_literal: false


module CryptoExpert
  module Binance
    # map the Spot Pair info
    class MiniPairMapper #< SignalCalculator
      # extend SignalCalculator
      def initialize(symbol)
        @symbol = symbol
        @now = CryptoExpert::Binance::TempMiniPairMapper.new(CryptoExpert::App.config.BINANCE_API_KEY).get(symbol)
        @history = CryptoExpert::Repository::TempMiniPairs.find_symbol(symbol)
        @calculator = CryptoExpert::Binance::SignalCalculator
      end

      def get
        data = {}
        data['symbol'] = @symbol
        data['now'] = @now
        data['history'] = @history
        MiniPairMapper.build_entity(data,@calculator)
      end

      def self.build_entity(data,calculator)
        DataMapper.new(data,calculator).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data,calculator)
          @data = data
          @calculator = calculator
        end

        def build_entity
          Entity::MiniPair.new(
            symbol: symbol,
            increase_percent: increase_percent,
            signal: signal
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
            puts @data['now']
            puts @data['history']
            (@data['now'].volume - @data['history'].volume)*100 / @data['history'].volume
          end
        end
        
        def signal
          # puts CryptoExpert::Binance::SignalCalculator.minipair_volume_thres(50)
          @calculator.minipair_volume_thres(increase_percent)
        end
        
      end
    end
  end
end
