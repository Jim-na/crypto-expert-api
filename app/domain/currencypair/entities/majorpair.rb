# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
module CryptoExpert
  # Model for CurrencyPair
  module Entity
    # Domain entity for team members
    class MajorPair < Dry::Struct
      include Dry.Types

      attribute :symbol,        Strict::String
      attribute :datetime,         DateTime.optional
      attribute :volume,         Float.optional
      attribute :funding_rate,         Float.optional
      attribute :longshort_ratio,         Float.optional
      attribute :open_interest,         Float.optional
    end
  end
end
