# frozen_string_literal: true

module CryptoExpert
  module Repository
    # Repository for MiniPairs
    class MiniPairs
      def self.all
        Database::MiniPairOrm.all.map { |minipair| rebuild_entity(minipair) }
      end

      def self.find_symbol(symbol)
        rebuild_entity Database::MiniPairOrm.first(symbol: symbol)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::MiniPairOrm.new(
          symbol: db_record.symbol,
          volume: db_record.volume,
          time: db_record.time
        )
      end

      def self.db_find_or_create(entity)
        Database::MiniPairOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
