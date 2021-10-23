# frozen_string_literal: true

require 'http'
require 'yaml'
require 'openssl'

BASIC_URL = 'https://api.binance.com/api/v3/'
Future_URL = 'https://fapi.binance.com/'
Funding_Rate_API = 'fapi/v1/fundingRate'
config = YAML.safe_load(File.read('../config/secrets.yml'))

# push request to binance with token
class Request
    def initialize(resource_root, token)
        @resource_root = resource_root
        @token = token
    end
    def get(url)
        if @token
            HTTP.headers('Content-Type' => 'application/json',
                'X-MBX-APIKEY' => @token['apikey']).get("#{@resource_root}#{url}")
            Response.new(http_response).tap do |response|
                raise(response.error) unless response.successful?
            end
        else
            HTTP.headers('Content-Type' => 'application/json').get(url)
        end
    end

end


response = Request.new(Future_URL,nil).get(Funding_Rate_API)
project = response.parse
fundingRate = {}
# project.map{|_| puts project['symbol']}
project.map{|pair| fundingRate[pair['symbol']] = pair['fundingRate'] }
File.write('test.yml', fundingRate.to_yaml)





=begin
def funding_rate_get(url,config)
    HTTP.headers('Content-Type' => 'application/json',
                'X-MBX-APIKEY' => config['apikey']).get(url) 
end

funding_rate_get("#{Future_URL}#{Funding_Rate_API}",config)
# puts config['apikey']

response = HTTP.headers('Content-Type' => 'application/json',
                'X-MBX-APIKEY' => config['apikey']).get("#{Future_URL}#{Funding_Rate_API}") 
project = response.parse
fundingRate = {}
# project.map{|_| puts project['symbol']}
project.map{|pair| fundingRate[pair['symbol']] = pair['fundingRate'] }
File.write('fundingRate.yml', fundingRate.to_yaml)


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

=end