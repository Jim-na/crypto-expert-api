# frozen_string_literal: true

require 'dry-validation'

module CryptoExpert
  module Forms
    class NewSymbol < Dry::Validation::Contract
      SYMBOL_REGEX = %r{[a-zA-Z]*USDT}.freeze

      params do
        required(:symbol).filled(:string)
      end

      rule(:symbol) do
        unless SYMBOL_REGEX.match?(value)
          key.failure('is an invalid USDT based symbol')
        end
      end
    end
  end
end