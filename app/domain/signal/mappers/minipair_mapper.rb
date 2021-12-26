# frozen_string_literal: false

module CryptoExpert
  module Binance
    # map the Spot Pair info
    # < SignalCalculator
    class MiniPairMapper
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
        MiniPairMapper.build_entity(data, @calculator)
      end

      def self.build_entity(data, calculator)
        DataMapper.new(data, calculator).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, calculator)
          @data = data
          @calculator = calculator.new(@data, volume_change_percent, spot_change_percent)
        end

        def build_entity
          Entity::MiniPair.new(
            symbol: symbol,
            volume_change_percent: volume_change_percent,
            signal: signal,
            signal_score: signal_score,
            time: time,
            spot_volume: spot_volume,
            spot_closeprice: spot_closeprice,
            funding_rate: funding_rate,
            longshort_ratio: longshort_ratio,
            open_interest: open_interest,
            spot_change_percent: spot_change_percent,
            funding_rate_history: funding_rate_history,
            longshort_ratio_history: longshort_ratio_history,
            open_interest_history: open_interest_history
          )
        end

        private

        def symbol
          @data['symbol']
        end

        def volume_change_percent
          if @data['history'].nil?
            0.0
          else
            (@data['now'].spot_volume - @data['history'].spot_volume) * 100 / @data['history'].spot_volume
          end
        end

        def spot_change_percent
          if @data['history'].nil?
            0.0
          else
            (@data['now'].spot_closeprice - @data['history'].spot_closeprice) * 100 / @data['history'].spot_closeprice
          end
        end

        def signal
          # puts CryptoExpert::Binance::SignalCalculator.new(@data,volume_change_percent,spot_change_percent).signal_output
          @calculator.signal_output
        end

        def signal_score
          @calculator.signal_score_output
        end

        def time
          @data['now'].time
        end

        # get data now
        def spot_volume
          @data['now'].spot_volume
        end

        def spot_closeprice
          @data['now'].spot_closeprice
        end

        def funding_rate
          @data['now'].funding_rate
        end

        def longshort_ratio
          @data['now'].longshort_ratio
        end

        def open_interest
          @data['now'].open_interest
        end

        def funding_rate_history
          if @data['history'].nil?
            0.0
          else
            @data['history'].funding_rate
          end
        end

        def longshort_ratio_history
          if @data['history'].nil?
            0.0
          else
            @data['history'].longshort_ratio
          end
        end

        def open_interest_history
          if @data['history'].nil?
            0.0
          else
            @data['history'].open_interest
          end
        end
      end
    end
  end
end
