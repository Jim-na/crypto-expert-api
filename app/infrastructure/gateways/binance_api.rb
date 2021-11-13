# frozen_string_literal: true

require_relative 'http_api'
# require_relative 'currencypair'
module CryptoExpert
  # library for Binance Web API
  module Binance
    # library for Binance Web API
    class Api
      include HttpApi
      BASIC_URL = 'https://api.binance.com/'
      FUTURE_URL = 'https://fapi.binance.com/'
      TIME_INTERVAL = '1h'
      LIMIT = 1
      
      def initialize(token)
        @token = token
      end

      # get the target currency pair information
      def spotpair(symbol)
        HttpApi::Request.new(BASIC_URL, nil).get("api/v3/ticker/price?symbol=#{symbol}").parse
      end
      
      def spotpair_klines(symbol)
        HttpApi::Request.new(BASIC_URL, nil).get("api/v3/klines?symbol=#{symbol}&interval=#{TIME_INTERVAL}&limit=#{LIMIT+1}").parse
      end

      # get the target currency pair information
      def futurepair(symbol)
        HttpApi::Request.new(FUTURE_URL, @token).get("fapi/v1/premiumIndex?symbol=#{symbol}").parse
      end
      
      def futurepair_klines(symbol)
        HttpApi::Request.new(FUTURE_URL, @token).get("fapi/v1/klines?symbol=#{symbol}&interval=#{TIME_INTERVAL}&limit=#{LIMIT+1}").parse
      end
      
      def longshort_ratio(symbol)
        HttpApi::Request.new(FUTURE_URL, @token).get("futures/data/globalLongShortAccountRatio?symbol=#{symbol}&period=#{TIME_INTERVAL}&limit=#{LIMIT}").parse
      end
      
      def open_interest(symbol)
        HttpApi::Request.new(FUTURE_URL, @token).get("futures/data/openInterestHist?symbol=#{symbol}&period=#{TIME_INTERVAL}&limit=#{LIMIT}").parse
      end
      
      def funding_rate(symbol)
        HttpApi::Request.new(FUTURE_URL, @token).get("fapi/v1/fundingRate?symbol=#{symbol}&limit=#{LIMIT}").parse
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
