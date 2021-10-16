# frozen_string_literal: true

require 'http'
require_relative 'CurrencyPair'

module CryptoExpert
  # library for Binance Web API
  class BinanceApi
    attr_reader :currencypair_list

    API_PROJECT_ROOT = 'https://api.binance.com/api/v3'

    module Errors
      class BadRequest < StandardError; end

      class NotFound < StandardError; end

      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      400 => Errors::BadRequest,
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(token)
      @binance_token = token
      @currencypair_list = currencylist_get
    end

    def currencypair(symbol)
      response = call_binance_api("ticker/price?symbol=#{symbol}").parse
      CurrencyPair.new(response['symbol'], response['price'])
    end

    # format binance api path (URL)
    def call_binance_api(path)
      binance_url = "#{API_PROJECT_ROOT}/#{path}"
      response = HTTP.headers('Content-Type' => 'application/json').get(binance_url)
      successful?(response) ? response : raise(HTTP_ERROR[response.code])
    end

    # get the list of currencypair in binance
    def currencylist_get
      response = call_binance_api('exchangeInfo')
      response.parse['symbols'].map { |pair| pair['symbol'] }
    end

    def successful?(response)
      !HTTP_ERROR.keys.include?(response.code)
    end
  end
end
