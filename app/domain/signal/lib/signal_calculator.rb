# frozen_string_literal: true

module CryptoExpert
  module Binance
    # pair matrix calculator
    class SignalCalculator
      # BULL = 1 HOLD = 0 BEAR = -1
      VOL_BULL_THRES = 20
      VOL_BEAR_THRES = -20
      LS_BULL_THRES = 15
      LS_BEAR_THRES = -10
      OI_BULL_THRES = 10
      OI_BEAR_THRES = -12
      
      def initialize(data,volume_change_percent,spot_change_percent)
        @data = data
        @volume_change_percent = volume_change_percent
        @spot_change_percent = spot_change_percent
        @funding_rate = @data['now'].funding_rate
        @longshort_ratio = @data['now'].longshort_ratio
        @open_interest = @data['now'].open_interest
      end
      
      def signal_output
        # "hi"
        if open_interest_change > 0 && longshort_ratio_change <0 && volume_thres>0
          "BULL"
        elsif open_interest_change < 0 && longshort_ratio_change>=0 && volume_thres<0
          "BEAR"
        else
          "HOLD"
        end
        # signal = open_interest_change + longshort_ratio_change + volume_thres
      end
      # TODO : define price movement and L/S ratio... etc then calculate signal
      # This is the original simple version.
      def volume_thres
        if @volume_change_percent > VOL_BULL_THRES
          1
        elsif @volume_change_percent < VOL_BEAR_THRES
          -1
        else
          0
        end
      end
      
      def spot_direction
        if @spot_change_percent > 0 # BULL
          1
        else
          0
        end
      end
      
      def funding_rate_change
        if @data['now'].funding_rate > @data['history'].funding_rate
          1
        else
          -1
        end
      end
      
      def longshort_ratio_change
        if @data['history'].nil?
          0
        else
          if @data['now'].funding_rate > @data['history'].funding_rate
            1
          else
            -1
          end
          # percent = (@data['now'].longshort_ratio - @data['history'].longshort_ratio) * 100 / @data['history'].longshort_ratio
          # if percent > LS_BULL_THRES
          #   1
          # elsif percent < LS_BEAR_THRES
          #   -1
          # else
          #   0
          # end
        end
      end
      
      def open_interest_change
        if @data['history'].nil?
          0
        else
          percent = (@data['now'].open_interest - @data['history'].open_interest) * 100 / @data['history'].open_interest
          if percent > OI_BULL_THRES
            1
          elsif percent < OI_BEAR_THRES
            -1
          else
            0
          end
        end        
      end

    end
  end
end
