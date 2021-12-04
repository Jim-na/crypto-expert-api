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
            volume_now: volume_now,
            signal: signal,
            time: time,
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
            puts @data['now'].symbol, @data['now'].volume
            puts @data['history'].symbol, @data['history'].volume
            (@data['now'].volume - @data['history'].volume)*100 / @data['history'].volume
          end
        end
        
        def signal
          # puts CryptoExpert::Binance::SignalCalculator.minipair_volume_thres(50)
          @calculator.minipair_volume_thres(increase_percent)
        end
        
        def time
          @data['now'].time
        end
        
        def volume_now
          @data['now'].volume
        end       
        # TODO: price movement direction
      end
    end
  end
end
