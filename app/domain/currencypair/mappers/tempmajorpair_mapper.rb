# frozen_string_literal: false

module CryptoExpert
  module Binance
    # map the Ｍajor Pair info
    class TempMajorPairMapper
      def initialize(token, gateway_class = Binance::Api)
        @token = token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def get(symbol)
        data = {}
        data['longshort_ratio'] = @gateway.longshort_ratio(symbol)
        data['open_interest'] = @gateway.open_interest(symbol)
        data['funding_rate'] = @gateway.funding_rate(symbol)
        data['spotpair_klines'] = @gateway.spotpair_klines(symbol)
        data['futurepair_klines'] = @gateway.futurepair_klines(symbol)
        TempMajorPairMapper.build_entity(data)
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
          Entity::TempMajorPair.new(
            symbol: symbol,    
            time:time,
            spot_volume:spot_volume,
            future_volume:future_volume,
            funding_rate: funding_rate,
            longshort_ratio:longshort_ratio,
            open_interest:open_interest
          )
        end
        private

        def symbol
          @data['longshort_ratio'][0]['symbol']
        end

        def time
          time = @data['longshort_ratio'][0]['timestamp']
          Time.at(time/1000).utc.to_datetime
        end
        
        def spot_volume
          @data['spotpair_klines'][0][5].to_f
        end
        
        def future_volume
          @data['futurepair_klines'][0][5].to_f
        end
        
        def funding_rate
          @data['funding_rate'][0]['fundingRate'].to_f
        end
        
        def longshort_ratio
          @data['longshort_ratio'][0]['longShortRatio'].to_f
        end
        
        def open_interest
          @data['open_interest'][0]['sumOpenInterest'].to_f
        end
      end
    end
  end
end
