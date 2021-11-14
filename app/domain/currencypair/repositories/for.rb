# frozen_string_literal: true

require_relative 'majorpairs'
require_relative 'minipairs'

module CryptoExpert
  module Repository
    # Finds the right repository for an entity object or class
    module For
      ENTITY_REPOSITORY = {
        Entity::MajorPair => MajorPairs,
        Entity::MiniPair => MiniPairs
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
