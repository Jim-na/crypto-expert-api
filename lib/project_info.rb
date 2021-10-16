# frozen_string_literal: true

require 'http'
require 'yaml'

BASIC_URL = 'https://api.binance.com/api/v3/'
# config = YAML.safe_load(File.read('config/secrets.yml'))

def binance_api(path)
  "#{BASIC_URL}#{path}"
end

def call_binance_url(url)
  HTTP.headers('Content-Type' => 'application/json').get(url)
end
binance_response = {}
results = {}
project_url = binance_api('exchangeInfo')
binance_response[project_url] = call_binance_url(project_url)
project = binance_response[project_url].parse

results['timezone'] = project['timezone']
results['serverTime'] = project['serverTime']
results['rateLimits'] = project['rateLimits']
results['symbols'] = project['symbols'].map { |pair| pair['symbol'] }

avgprice_url = binance_api('avgPrice?symbol=ETHBTC')
binance_response[project_url] = call_binance_url(avgprice_url)
avgprice = binance_response[project_url].parse
results['avgPrice'] = avgprice['price']

bad_avgprice_url = binance_api('avgPrice?symbol=TINAJIMBO')
binance_response[bad_avgprice_url] = call_binance_url(bad_avgprice_url)
binance_response[bad_avgprice_url].parse

File.write('spec/fixtures/results.yml', results.to_yaml)
