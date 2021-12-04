# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
module CryptoExpert
  # Model for CurrencyPair
  module Entity
    # Domain entity for mini currency pair
    class MiniPair < Dry::Struct
      include Dry.Types

      attribute :symbol,                Strict::String
      attribute :increase_percent,      Float.optional
      attribute :signal,                String.optional
      attribute :time,                  Integer.optional
      attribute :volume_now,            Float.optional
      # TODO: price movement direction 
      # price now - history
    end
  end
end
