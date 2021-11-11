# frozen_string_literal: true

require_relative 'spotpair'
require_relative 'exchangeinfo'

module CryptoExpert
  module Repository
    # Finds the right repository for an entity object or class
    module For
      ENTITY_REPOSITORY = {
        Entity::ExchangeInfo => ExchangeInfo,
        Entity::SpotPair => SpotPair
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
