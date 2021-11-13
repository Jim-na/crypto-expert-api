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

      def initialize(token)
        @token = token
      end

      # get the target currency pair information
      def spotpair(symbol)
        HttpApi::Request.new(BASIC_URL, nil).get("ticker/price?symbol=#{symbol}").parse
      end
      
      def spotpair_klines(symbol,time_interval,limit)
        HttpApi::Request.new(BASIC_URL, @token).get("api/v3/klines?symbol=#{symbol}&interval=#{time_interval}&limit=#{limit}").parse
      end

      # get the target currency pair information
      def futurepair(symbol)
        HttpApi::Request.new(FUTURE_URL, @token).get("fapi/v1/premiumIndex?symbol=#{symbol}").parse
      end
      
      def futurepair_klines(symbol,time_interval,limit)
        HttpApi::Request.new(FUTURE_URL, @token).get("fapi/v1/markPriceKlines?symbol=#{symbol}&interval=#{time_interval}&limit=#{limit}").parse
      end
      
      def longshort_ratio(symbol,time_interval,limit)
        HttpApi::Request.new(FUTURE_URL, @token).get("futures/data/globalLongShortAccountRatio?#{symbol}&period=#{time_interval}&limit=#{limit}").parse
      end
      
      def open_interest(symbol,time_interval,limit)
        HttpApi::Request.new(FUTURE_URL, @token).get("/futures/data/openInterestHist?#{symbol}&period=#{time_interval}&limit=#{limit}").parse
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
