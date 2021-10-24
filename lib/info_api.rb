# frozen_string_literal: true

require_relative 'binance_api'

module CryptoExpert
  # all the info needed
  class InfoApi
    def initialize(token)
      @binance = BinanceApi.new(token)
      ## TODO : @ftx?
      # @currencypair_list = currencylist_get
    end

    def currencypair(symbol)
      @binance.currencypair(symbol)
    end

    def currencypair_list
      @binance.currencypair_list
    end
  end
end
