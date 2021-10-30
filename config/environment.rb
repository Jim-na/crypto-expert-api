# frozen_string_literal: true

require 'roda'
require 'yaml'

module CryptoExpert
  # Configuration for the App
  class App < Roda
    # CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    BINANCE_TOKEN = YAML.safe_load(File.read('config/secrets.yml'))
  end
end
