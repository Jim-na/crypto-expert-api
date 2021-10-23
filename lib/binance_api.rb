# frozen_string_literal: true

require 'http'
require_relative 'CurrencyPair'

module CryptoExpert
  BASIC_URL = 'https://api.binance.com/api/v3/'
  FUTURE_URL = 'https://fapi.binance.com/'
  # all the info needed
  class Info
    attr_reader :currencypair_list

    def initialize(token)
      @token = token
      BinanceApi.new(@token)
      @currencypair_list = currencylist_get
    end

    def currencypair(symbol)
      response = BinanceApi::Request.new(BASIC_URL, nil).get("ticker/price?symbol=#{symbol}").parse
      CurrencyPair.new(response['symbol'], response['price'])
    end

    # get the list of currencypair in binance
    def currencylist_get
      response = BinanceApi::Request.new(BASIC_URL, nil).get('exchangeInfo').parse
      response['symbols'].map { |pair| pair['symbol'] }
    end
  end

  # library for Binance Web API
  class BinanceApi
    # attr_reader :currencypair_list

    def initialize(token)
      @binance_token = token
      # @currencypair_list = currencylist_get
    end

    # def currencypair(symbol)
    #   response = Request.new(BASIC_URL, nil).get("ticker/price?symbol=#{symbol}").parse
    #   CurrencyPair.new(response['symbol'], response['price'])
    # end

    # # get the list of currencypair in binance
    # def currencylist_get
    #   response = Request.new(BASIC_URL, nil).get('exchangeInfo').parse
    #   response['symbols'].map { |pair| pair['symbol'] }
    # end

    # http response error
    class Response < SimpleDelegator
      BadRequest = Class.new(StandardError)
      Unauthorized = Class.new(StandardError)
      NotFound = Class.new(StandardError)

      HTTP_ERROR = {
        400 => BadRequest,
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

    # push request to binance with token
    class Request
      def initialize(resource_root, token)
        @resource_root = resource_root
        @token = token
      end

      def get(url)
        http_response = if @token
                          HTTP.headers('Content-Type' => 'application/json',
                                       'X-MBX-APIKEY' => @token['apikey']).get("#{@resource_root}#{url}")
                        else
                          HTTP.headers('Content-Type' => 'application/json').get("#{@resource_root}#{url}")
                        end
        Response.new(http_response).tap do |response|
          raise(response.error) unless response.successful?
        end
      end
    end
  end
end
