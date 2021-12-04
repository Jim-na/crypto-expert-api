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
      attribute :volume_change_percent,      Float.optional
      attribute :signal,                String.optional
      attribute :time,                  Integer.optional
      attribute :spot_volume,                Float.optional
      attribute :spot_closeprice,       Float.optional
      attribute :funding_rate,          Float.optional
      attribute :longshort_ratio,       Float.optional
      attribute :open_interest,         Float.optional
      attribute :spot_change_percent,         Float.optional
      # TODO: price movement direction 
      # price now - history
    end
  end
end
