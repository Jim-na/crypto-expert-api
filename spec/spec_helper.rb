# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

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

MAJOR_SYMBOL = 'BTCUSDT'
MINI_SYMBOL = 'SOLUSDT'
