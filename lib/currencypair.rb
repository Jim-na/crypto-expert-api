# frozen_string_literal: true

module CryptoExpert
  # Model for CurrencyPair
  class CurrencyPair
    def initialize(symbol, price)
      @symbol = symbol
      @price = price
    end
  end
end
