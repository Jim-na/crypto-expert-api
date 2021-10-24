# frozen_string_literal: true

require_relative 'http_api'
require_relative 'CurrencyPair'
module CryptoExpert
  # library for Binance Web API
  class BinanceApi
    include HttpApi
    BASIC_URL = 'https://api.binance.com/api/v3/'
    FUTURE_URL = 'https://fapi.binance.com/'
    attr_reader :currencypair_list

    def initialize(token)
      @binance_token = token
      @currencypair_list = currencylist_get
    end

    # get the target currency pair information
    def currencypair(symbol)
      CurrencyPair.new(HttpApi::Request.new(BASIC_URL, @binance_token).get("ticker/price?symbol=#{symbol}").parse)
    end

    # get the list of currencypair in binance
    def currencylist_get
      response = HttpApi::Request.new(BASIC_URL, @binance_token).get('exchangeInfo').parse
      response['symbols'].map { |pair| pair['symbol'] }
    end
  end
end
