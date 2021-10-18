# frozen_string_literal: true

require 'http'
require 'yaml'
require 'openssl'

BASIC_URL = 'https://api.binance.com/api/v3/'
Future_URL = 'https://fapi.binance.com/'
Funding_Rate_API = 'fapi/v1/fundingRate'
config = YAML.safe_load(File.read('config/secrets.yml'))

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
