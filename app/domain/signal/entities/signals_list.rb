# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require_relative 'minipair'

module CryptoExpert
  # Model for CurrencyPair
  module Entity
    # Domain entity for mini currency pair
    class SignalsList < Dry::Struct
      include Dry.Types

      attribute :signals, Strict::Array.of(MiniPair)

      # price now - history
      def to_attr_hash
        hash = to_hash.reject { |key, _| [:id].include? key }
        hash[time].to_s
        hash
      end
    end
  end
end
