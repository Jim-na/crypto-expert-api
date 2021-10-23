# frozen_string_literal: true

require 'http'
require 'yaml'
require 'openssl'
# require_relative '../lib/CurrencyPair'

# BASIC_URL = 'https://api.binance.com/api/v3/'
# Future_URL = 'https://fapi.binance.com/'
# Funding_Rate_API = 'fapi/v1/fundingRate'
# config = YAML.safe_load(File.read('../config/secrets.yml'))
#
# Decorates HTTP responses from Github with success/error reporting
# class Response < SimpleDelegator
#     BadRequest = Class.new(StandardError)
#     Unauthorized = Class.new(StandardError)
#     NotFound = Class.new(StandardError)
#
#     HTTP_ERROR = {
#       400 => BadRequest,
#       401 => Unauthorized,
#       404 => NotFound
#     }.freeze
#
#     def successful?
#       HTTP_ERROR.keys.include?(code) ? false : true
#     end
#
#     def error
#       HTTP_ERROR[code]
#     end
# end
#
# push request to binance with token
# class Request
#     def initialize( resource_root, token)
#         @resource_root = resource_root
#         @token = token
#     end
#     def get(url)
#         if @token
#             http_response = HTTP.headers('Content-Type' => 'application/json',
#                 'X-MBX-APIKEY' => @token['apikey']).get("#{@resource_root}#{url}")
#             Response.new(http_response).tap do |response|
#                 raise(response.error) unless response.successful?
#             end
#         else
#             http_response = HTTP.headers('Content-Type' => 'application/json').get("#{@resource_root}#{url}")
#             Response.new(http_response).tap do |response|
#                 raise(response.error) unless response.successful?
#             end
#         end
#     end
# end
#
#
# response = Request.new(BASIC_URL,nil).get('exchangeInfo')
# info = response.parse
# results = {}
# results['timezone'] = info['timezone']
# results['serverTime'] = info['serverTime']
# results['rateLimits'] = info['rateLimits']
# results['symbols'] = info['symbols'].map { |pair| pair['symbol'] }
#
# response = Request.new(Future_URL,config).get(Funding_Rate_API)
# funding_rate = response.parse
# results['fundingRate'] = {}
# funding_rate.map { |pair| results['fundingRate'][pair['symbol']] = pair['fundingRate'] }
# # File.write('test.yml', fundingRate.to_yaml)
# File.write('test.yml', funding_rate.to_yaml)
#
#
# def currencypair(symbol)
#     response = Request.new(BASIC_URL,nil).get("ticker/price?symbol=#{symbol}").parse
#     # response = call_binance_api("ticker/price?symbol=#{symbol}").parse
#     CurrencyPair.new(response['symbol'], response['price'])
# end
# get the list of currencypair in binance
# def currencylist_get
#     response = Request.new(BASIC_URL,nil).get("exchangeInfo").parse
#     response.parse['symbols'].map { |pair| pair['symbol'] }
# end
#
# currencypair('ETHBTC')
# symbol = 'ETHBTC'
# response = Request.new(BASIC_URL,nil).get("ticker/price?symbol=#{symbol}").parse
# puts response
#
# response = Request.new(BASIC_URL,nil).get("exchangeInfo").parse
# puts response
#
#
#
# def funding_rate_get(url,config)
#     HTTP.headers('Content-Type' => 'application/json',
#                 'X-MBX-APIKEY' => config['apikey']).get(url)
# end
#
# funding_rate_get("#{Future_URL}#{Funding_Rate_API}",config)
# puts config['apikey']
#
# response = HTTP.headers('Content-Type' => 'application/json',
#                 'X-MBX-APIKEY' => config['apikey']).get("#{Future_URL}#{Funding_Rate_API}")
# project = response.parse
# fundingRate = {}
# project.map{|_| puts project['symbol']}
# project.map{|pair| fundingRate[pair['symbol']] = pair['fundingRate'] }
# File.write('fundingRate.yml', fundingRate.to_yaml)
#
#
#   # Decorates HTTP responses from Github with success/error reporting
#   class Response < SimpleDelegator
#     Unauthorized = Class.new(StandardError)
#     NotFound = Class.new(StandardError)
#
#     HTTP_ERROR = {
#         401 => Unauthorized,
#         404 => NotFound
#     }.freeze
#
#     def successful?
#         HTTP_ERROR.keys.include?(code) ? false : true
#     end
#
#     def error
#         HTTP_ERROR[code]
#     end
# end
#

# Model for CurrencyPair
class CurrencyPair
    attr_reader :symbol, :price

    def initialize(symbol, price)
        @symbol = symbol
        @price = price
    end
end

class BinanceApi
 
    def initialize(token)
      @binance_token = token
    end
  
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
require 'http'

BASIC_URL = 'https://api.binance.com/api/v3/'
FUTURE_URL = 'https://fapi.binance.com/'
# library for Binance Web API
class Info
  attr_reader :currencypair_list
  def initialize(token)
    @binance_token = token
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



SYMBOL = 'ETHBTC'
puts Info.new('token').currencylist_get()