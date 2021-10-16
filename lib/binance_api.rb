# frozen_string_literal: true

require 'http'
require_relative 'CurrencyPair'

module CryptoExpert
  # library for Binance Web API
  class BinanceApi
    API_PROJECT_ROOT = 'https://api.binance.com/api/v3/'

    module Errors
      class NotFound < StandardError; end

      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(token)
      @binance_token = token
      @currencypair_list = currencylist_get
    end

    def currencypair(symbol)
      return false unless @currencypair_list.include?(symbol) # TODO : error raising?

      response = call_binance_api('/ticker/price?symbol={#symbol}').parse
      CurrencyPair.new(response['symbol'], response['price'])
    end

    # format binance api path (URL)
    def call_binance_api(_path)
      binance_url = "#{API_PROJECT_ROOT}/#{path}"
      HTTP.headers('Content-Type' => 'application/json').get(binance_url)
    end

    # get the list of currencypair in binance
    def currencylist_get
      response = call_binance_api('/exchangeInfo')
      response.parse['symbols'].map { |pair| pair['symbol'] }
    end
  end
end
