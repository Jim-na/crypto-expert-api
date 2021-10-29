# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
module CryptoExpert
  # Model for CurrencyPair
  module Entity
    # Domain entity for team members
    class SpotPair < Dry::Struct
      include Dry.Types

      attribute :symbol,        Strict::String
      attribute :price,         String.optional
      # attribute :futureprice,   Float.optional
      # attribute :fundingrate,   Float.optional
    end
  end

  # class CurrencyPair
  #   attr_reader :symbol, :price

  #   def initialize(response)
  #     @symbol = response['symbol']
  #     @price = response['price']
  #   end
  # end
end
