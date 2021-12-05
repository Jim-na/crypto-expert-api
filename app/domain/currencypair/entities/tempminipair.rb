# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
module CryptoExpert
  # Model for CurrencyPair
  module Entity
    # Domain entity for team members
    class TempMiniPair < Dry::Struct
      include Dry.Types

      attribute :symbol,        Strict::String
      attribute :time,          Integer.optional
      attribute :spot_volume,         Float.optional
      attribute :future_volume,       Float.optional
      attribute :funding_rate,        Float.optional
      attribute :longshort_ratio,     Float.optional
      attribute :open_interest,       Float.optional
      attribute :spot_closeprice,     Float.optional
      # TODO: price movement direction
      # combine major and minipair
      def to_attr_hash
        hash = to_hash.reject { |key, _| [:id].include? key }
        hash[time].to_s
        hash
      end
      
    end
  end
end
