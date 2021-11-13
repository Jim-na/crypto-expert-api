# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require  'minitest/autorun'
require  'minitest/rg'
require  'yaml'
require  'vcr'
require  'webmock'

require_relative '../init'

CORRECT = YAML.safe_load(File.read('./spec/fixtures/results.yml'))
BINANCE_API_KEY = CryptoExpert::App.config.BINANCE_API_KEY

SYMBOL = 'BTCUSDT'


