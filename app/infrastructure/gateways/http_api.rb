# frozen_string_literal: true

require 'http'
module CryptoExpert
  module HttpApi
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
                                       'X-MBX-APIKEY' => @token).get("#{@resource_root}#{url}")
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
