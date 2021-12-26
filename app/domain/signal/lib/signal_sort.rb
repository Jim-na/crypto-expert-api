# frozen_string_literal: true

module CryptoExpert
    module Binance
      # pair matrix sort
      class SignalSort
        # BULL = 1 HOLD = 0 BEAR = -1
        VOL_BULL_THRES = 20
        VOL_BEAR_THRES = -20
        LS_BULL_THRES = 15
        LS_BEAR_THRES = -10
        OI_BULL_THRES = 10
        OI_BEAR_THRES = -12
        
        def initialize(data)
          @data = data
        end
        
        def get_list
        #   puts @data[0]
          @data.sort_by { |p| -p.signal_score }
        end
  
      end
    end
end
  