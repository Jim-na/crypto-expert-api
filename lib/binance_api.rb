# frozen_string_literal: true

require 'http'
require_relative 'CurrencyPair'

module CryptoExpert
  BASIC_URL = 'https://api.binance.com/api/v3/'
  FUTURE_URL = 'https://fapi.binance.com/'
  # library for Binance Web API
  class BinanceApi
    attr_reader :currencypair_list

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
      binance_url = "#{BASIC_URL}/#{path}"
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
  # push request to binance with token
  class Request
    def initialize(resource_root, token)
        @resource_root = resource_root
        @token = token
    end
    def get(url)
        HTTP.headers('Content-Type' => 'application/json',
            'X-MBX-APIKEY' => @token['apikey']).get("#{@resource_root}#{url}") 
        # Response.new(http_response).tap do |response|
        #     raise(response.error) unless response.successful?
        # end
    end
  end
  # Decorates HTTP responses from Github with success/error reporting
  class Response < SimpleDelegator
    Unauthorized = Class.new(StandardError)
    NotFound = Class.new(StandardError)

    HTTP_ERROR = {
      401 => Unauthorized,
      404 => NotFound
    }.freeze

    def successful?
      HTTP_ERROR.keys.include?(code) ? false : true
    end

    def error
      HTTP_ERROR[code]
    end
  end
  
end
