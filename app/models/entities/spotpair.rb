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
      attribute :price,         Float.optional
      attribute :exchange,      String.optional
    end
  end

end
