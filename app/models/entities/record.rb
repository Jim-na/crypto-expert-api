# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
module CryptoExpert
  # Model for CurrencyPair
  module Entity
    # Domain entity for transaction record
    class Record < Dry::Struct
      include Dry.Types
    
      attribute :addqty, Float.optional
      attribute :minusqty, Float.optional
      attribute :price, Float.optional
      attribute :timeStamp, DateTime.optional
      attribute :buy, Bool.optional
    end
  end
end
