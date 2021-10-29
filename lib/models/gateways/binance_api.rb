# frozen_string_literal: true

require_relative 'http_api'
# require_relative 'currencypair'
module CryptoExpert
  # library for Binance Web API
  module Binance
    # library for Binance Web API
    class Api
      include HttpApi
      BASIC_URL = 'https://api.binance.com/api/v3/'
      FUTURE_URL = 'https://fapi.binance.com/'
      attr_reader :currencypair_list

      def initialize(token)
        @token = token
      end

      # get the target currency pair information
      def spotpair(symbol)
        HttpApi::Request.new(BASIC_URL, nil).get("ticker/price?symbol=#{symbol}").parse
      end

      # get the target currency pair information
      def futurepair(symbol)
        HttpApi::Request.new(FUTURE_URL, @token).get("fapi/v1/premiumIndex?symbol=#{symbol}").parse
      end

      # get the list of currencypair in binance
      def exchange_info
        HttpApi::Request.new(BASIC_URL, nil).get('exchangeInfo').parse
        # response['symbols'].map { |pair| pair['symbol'] }
      end

      def fundingrate_list
        HttpApi::Request.new(FUTURE_URL, @token).get('fapi/v1/fundingRate').parse
      end
    end
  end
end
