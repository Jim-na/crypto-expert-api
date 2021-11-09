# frozen_string_literal: true

module CryptoExpert
  module Repository
    # Repository for ExchangeInfo
    class ExchangeInfo
      def self.find_name(exchange_name)
        db_exchange = Database::ExchangeOrm
                      .where(exchangename: exchange_name)
                      .first
        db_currencylist = Database::CurrencyListOrm
                          .where(exchangeid: db_exchange.id)
                          .all
        db_fundingratelist = Database::FundingRateListOrm
                             .where(exchangeid: db_exchange.id)
                             .all
        rebuild_entity(db_exchange, db_currencylist, db_fundingratelist)
      end

      def self.find_exchangeid(exchange_name)
        Database::ExchangeOrm.find_or_create(exchangename: exchange_name)[:id]
      end

      def self.find_exchangename(exchange_id)
        Database::ExchangeOrm.first(id: exchange_id)[:exchangename]
      end

      def self.rebuild_entity(db_exchange, db_currencylist, db_fundingratelist)
        return nil unless db_exchange && db_currencylist && db_fundingratelist

        fundinghash = {}
        db_fundingratelist.map { |val| fundinghash[val[:symbol]] = val[:price] }
        Entity::Exchangeinfo.new(
          name: db_exchange.exchangename,
          timezone: db_exchange.timezone,
          currencylist: db_currencylist.map { |val| val[:symbol] },
          fundingratelist: fundinghash
        )
      end

      def self.db_find_or_create(entity)
        val = Database::ExchangeOrm.find_or_create({ 'exchangename': entity.name })
        entity.currencylist.each do |currencypair|
          Database::CurrencyListOrm.find_or_create({ 'symbol': currencypair, 'exchangeid': val[:id] })
        end
        entity.fundingratelist.each do |symbol, fundingrate|
          Database::FundingRateListOrm.find_or_create({ 'symbol': symbol, 'exchangeid': val[:id],
                                                        'price': fundingrate })
        end
      end
    end
  end
end
