# frozen_string_literal: true

module CryptoExpert
  module Repository
    # Repository for MiniPairs
    class Signals
      def self.all
        Database::SignalOrm.all.map { |minipair| rebuild_entity(minipair) }
      end

      def self.find_symbol(symbol)
        rebuild_entity Database::SignalOrm.first(symbol: symbol)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::MiniPair.new(
          symbol: db_record.symbol,
          volume_change_percent: db_record.volume_change_percent,
          signal: db_record.signal,
          signal_score: db_record.signal_score,
          time: db_record.time,
          spot_volume: db_record.spot_volume,
          spot_closeprice: db_record.spot_closeprice,
          funding_rate: db_record.funding_rate,
          longshort_ratio: db_record.longshort_ratio,
          open_interest: db_record.open_interest,
          spot_change_percent: db_record.spot_change_percent,
          funding_rate_history: db_record.funding_rate_history,
          longshort_ratio_history: db_record.longshort_ratio_history,
          open_interest_history: db_record.open_interest_history
        )
      end

      def self.create(entity)
        rebuild_entity Database::SignalOrm.create(entity.to_attr_hash)
      end
    end
  end
end
