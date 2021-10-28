# frozen_string_literal: true

module CryptoExpert
  # Model for CurrencyPair
  class CurrencyPair
    attr_reader :symbol, :price

    def initialize(response)
      @symbol = response['symbol']
      @price = response['price']
    end
  end
end
