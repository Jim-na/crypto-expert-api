# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require  'minitest/autorun'
require  'minitest/rg'
require  'yaml'
require  'vcr'
require  'webmock'

require_relative '../lib/mappers/info_api'
require_relative '../init'

CORRECT = YAML.safe_load(File.read('../spec/fixtures/results.yml'))
SYMBOL = 'ETHBTC'

CASSETTES_FOLDER = '../spec/fixtures/cassettes'
CASSETTES_FILE = 'info_api'
