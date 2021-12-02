# frozen_string_literal: true

module CryptoExpert
  module Binance
      # pair matrix calculator
    class SignalCalculator
        def initialize()
        end
        
        def self.minipair_volume_thres(percent)
           if percent > 20
                return 'BULL'
           else
                return 'BEAR'
           end
        end
        
    end
  end
end