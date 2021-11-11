# frozen_string_literal: true

require_relative 'exchangeinfo'

module CryptoExpert
  module Repository
    # Repository for Members
    class SpotPair
      def self.all
        Database::SpotOrm.all.map { |spotpair| rebuild_entity(spotpair) }
      end

      def self.find_symbol(symbol)
        rebuild_entity Database::SpotOrm.first(symbol: symbol)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        exchange = ExchangeInfo.find_exchangename(db_record[:exchangeid])
        Entity::SpotPair.new(
          symbol: db_record.symbol,
          price: db_record.price,
          exchange: exchange
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Members.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(entity)
        Database::SpotOrm.find_or_create(symbol: entity.symbol,
                                         exchangeid: ExchangeInfo.find_exchangeid(entity.exchange), price: entity.price)
      end

      def self.create(entity)
        Database::SpotOrm.create(entity)
      end
    end
  end
end
