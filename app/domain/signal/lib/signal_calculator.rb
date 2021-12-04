# frozen_string_literal: true

module CryptoExpert
  module Binance
      # pair matrix calculator
    class SignalCalculator
        BULL_THRES = 32
        BEAR_THRES = -35
        def initialize()
        end
        # TODO : define price movement and L/S ratio... etc then calculate signal
        # This is the original simple version.
        def self.minipair_volume_thres(percent)
           if percent > BULL_THRES
                return 'BULL'
           elsif percent < BEAR_THRES
                return 'BEAR'
           else
                return 'HOLD'
           end
        end
        
    end
  end
end