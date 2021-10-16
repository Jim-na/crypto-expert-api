# frozen_string_literal: true

require 'http'
require 'yaml'
require 'openssl'

BASIC_URL = 'https://api.binance.com/api/v3/'
Future_URL = 'https://fapi.binance.com/'
config = YAML.safe_load(File.read('config/secrets.yml'))

def spot_api(path)
  "#{BASIC_URL}#{path}"
end
def future_api(path)
  "#{Future_URL}#{path}"
end

def call_spot_url(url)
  HTTP.headers('Content-Type' => 'application/json').get(url)
end
def call_future_url(url,config)
    HTTP.headers('Content-Type' => 'application/json',
                'X-MBX-APIKEY' => config['apikey']).get(url) 
end

binance_response = {}
results = {}
exchangeInfo_url = spot_api('exchangeInfo')
binance_response[exchangeInfo_url] = call_spot_url(exchangeInfo_url)
info = binance_response[exchangeInfo_url].parse

results['timezone'] = info['timezone']
results['serverTime'] = info['serverTime']
results['rateLimits'] = info['rateLimits']
results['symbols'] = info['symbols'].map { |pair| pair['symbol'] }
# puts results['symbols'].size
avgprice_url = spot_api('avgPrice?symbol=ETHBTC')
binance_response[avgprice_url] = call_spot_url(avgprice_url)
avgprice = binance_response[avgprice_url].parse
results['avgPrice'] = avgprice['price']

bad_avgprice_url = spot_api('avgPrice?symbol=TINAJIMBO')
binance_response[bad_avgprice_url] = call_spot_url(bad_avgprice_url)
binance_response[bad_avgprice_url].parse

results['fundingRate'] = {}
funding_rate_url = future_api('fapi/v1/fundingRate')
binance_response[funding_rate_url] = call_future_url(funding_rate_url,config)
funding_rate = binance_response[funding_rate_url].parse
funding_rate.map{|pair| results['fundingRate'][pair['symbol']] = pair['fundingRate'] }

File.write('spec/fixtures/results.yml', results.to_yaml)
