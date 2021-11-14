# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
module CryptoExpert
  # Model for CurrencyPair
  module Entity
    # Domain entity for team members
    class MiniPair < Dry::Struct
      include Dry.Types

      attribute :symbol,        Strict::String
      attribute :time,          DateTime.optional
      attribute :volume,        Float.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end
