# frozen_string_literal: false

module CryptoExpert
  module Binance
    # map the exchange info
    class ExchangeMapper
      def initialize(token, gateway_class = Binance::Api)
        @token = token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
         
      end

      def get
        info = @gateway.exchange_info
        all_funding_rate = @gateway.fundingrate_list
        ExchangeMapper.build_entity(info, all_funding_rate)
      end

      def self.build_entity(data, all_funding_rate)
        DataMapper.new(data, all_funding_rate).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, all_funding_rate)
          @data = data
          @all_funding_rate = all_funding_rate
          @name = 'Binance'
        end

        def build_entity
          Entity::ExchangeInfo.new(
            currencylist: currencylist,
            timezone: timezone,
            fundingratelist: fundingratelist,
            name: name
          )
        end

        private

        def currencylist
          @data['symbols'].map { |pair| pair['symbol'] }
        end

        def timezone
          @data['timezone']
        end

        def fundingratelist
          results = {}
          @all_funding_rate.map { |pair| results[pair['symbol']] = pair['fundingRate'] }
          results
        end
        def name
          @name
        end

      end
    end
  end
end
