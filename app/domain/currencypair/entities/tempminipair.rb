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
      attribute :volume,        Float.optional

      def to_attr_hash
        hash = to_hash.reject { |key, _| [:id].include? key }
        hash[time].to_s
        hash
      end
    end
  end
end
