# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
module CryptoExpert
  # Model for CurrencyPair
  module Entity
    # Domain entity for team members
    class ExchangeInfo < Dry::Struct
      include Dry.Types

      attribute :currencylist, Array.optional
      attribute :timezone, String.optional
      attribute :fundingratelist, Hash.optional
    end
  end
end
