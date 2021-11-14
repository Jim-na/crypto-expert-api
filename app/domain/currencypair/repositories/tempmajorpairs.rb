# frozen_string_literal: true

module CryptoExpert
  module Repository
    # Repository for MajorPairs
    class TempMajorPairs
      def self.all
        Database::TempMajorPairOrm.all.map { |majorpair| rebuild_entity(majorpair) }
      end

      def self.find_symbol(symbol)
        rebuild_entity Database::TempMajorPairOrm.first(symbol: symbol)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::TempMajorPair.new(
          symbol: db_record.symbol,
          spot_volume: db_record.spot_volume,
          funding_rate: db_record.funding_rate,
          open_interest: db_record.open_interest,
          future_volume: db_record.future_volume,
          longshort_ratio: db_record.longshort_ratio,
          time: db_record.time.to_i
        )
      end

      def self.db_find_or_create(entity)
        Database::TempMajorPairOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
