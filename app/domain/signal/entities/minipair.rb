# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
module CryptoExpert
  # Model for CurrencyPair
  module Entity
    # Domain entity for mini currency pair
    class MiniPair < Dry::Struct
      include Dry.Types

      attribute :symbol, Strict::String
      attribute :volume_change_percent, Float.optional
      attribute :signal,                String.optional
      attribute :signal_score,          Integer.optional
      attribute :time,                  Integer.optional
      attribute :spot_volume,           Float.optional
      attribute :spot_closeprice,       Float.optional
      attribute :funding_rate,          Float.optional
      attribute :longshort_ratio,       Float.optional
      attribute :open_interest,         Float.optional
      attribute :spot_change_percent,   Float.optional
      attribute :funding_rate_history,          Float.optional
      attribute :longshort_ratio_history,       Float.optional
      attribute :open_interest_history,         Float.optional
      # price now - history
      def to_attr_hash
        hash = to_hash.reject { |key, _| [:id].include? key }
        hash[time].to_s
        hash
      end
    end
  end
end
