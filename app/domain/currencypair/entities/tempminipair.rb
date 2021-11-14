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
        to_hash.reject { |key, _| [:id].include? key }
      end
      def datetime
        Time.at(self.time/1000).utc.to_datetime
      end
    end
  end
end
