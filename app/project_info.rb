# frozen_string_literal: true

require 'http'
require 'yaml'
require 'openssl'

BASIC_URL = 'https://api.binance.com/'
FUTURE_URL = 'https://fapi.binance.com/'
TIME_INTERVAL = '1h'
LIMIT = 1
SYMBOL = "BTCUSDT"
config = YAML.safe_load(File.read('../config/secrets.yml'))
config = config['test']['BINANCE_API_KEY']
# puts config
def spot_api(path)
  "#{BASIC_URL}#{path}"
end

def future_api(path)
  "#{FUTURE_URL}#{path}"
end

def call_spot_url(url)
  HTTP.headers('Content-Type' => 'application/json').get(url).parse
end

def call_future_url(url, config)
  HTTP.headers('Content-Type' => 'application/json',
               'X-MBX-APIKEY' => config ).get(url).parse
end

majorpair = {}

spot_klines_url = spot_api("api/v3/klines?symbol=#{SYMBOL}&interval=#{TIME_INTERVAL}&limit=#{LIMIT+1}")
future_klines_url = future_api("fapi/v1/klines?symbol=#{SYMBOL}&interval=#{TIME_INTERVAL}&limit=#{LIMIT+1}")
longshort_ratio = future_api("futures/data/globalLongShortAccountRatio?symbol=#{SYMBOL}&period=#{TIME_INTERVAL}&limit=#{LIMIT}")
open_interest = future_api("futures/data/openInterestHist?symbol=#{SYMBOL}&period=#{TIME_INTERVAL}&limit=#{LIMIT}")
funding_rate = future_api("fapi/v1/fundingRate?symbol=#{SYMBOL}&limit=#{LIMIT}")


time = call_future_url(longshort_ratio,config)[0]['timestamp']
majorpair[SYMBOL] = {}
majorpair[SYMBOL]['time'] = Time.at(time/1000).utc.to_datetime
majorpair[SYMBOL]['spot_volume'] = call_spot_url(spot_klines_url)[0][5]
majorpair[SYMBOL]['future_volume'] = call_future_url(future_klines_url,config)[0][5]
majorpair[SYMBOL]['longshort_ratio'] = call_future_url(longshort_ratio,config)[0]['longShortRatio']
majorpair[SYMBOL]['open_interest'] = call_future_url(open_interest,config)[0]['sumOpenInterest']
majorpair[SYMBOL]['funding_rate'] = call_future_url(funding_rate,config)[0]['fundingRate']
puts majorpair

File.write('../spec/fixtures/results.yml', majorpair.to_yaml)
