# frozen_string_literal: false

module CryptoExpert
    module Binance
      # map the Spot Pair info
      class MiniPairMapper
        def initialize(token)
          @now = TempMiniPairMapper.new(CryptoExpert::App.config.BINANCE_API_KEY).get(token)
          @history = CryptoExpert::Repository::TempMiniPairs.find_symbol(symbol)
        end
  
        def get(symbol)
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
              time:time,
              volume:spot_volume,
            )
          end
          private
  
          def symbol
            @data['symbol']
          end
  
        end
      end
    end
end
  