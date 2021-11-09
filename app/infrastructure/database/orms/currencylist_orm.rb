# frozen_string_literal: true

require 'sequel'

module CryptoExpert
  module Database
    # Object-Relational Mapper for Members
    class CurrencyListOrm < Sequel::Model(:currencylist)
      many_to_one :exchange,
                  class: :'CryptoExpert::Database::ExchangeOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(info)
        first(symbol: info[:symbol], exchangeid: info[:exchangeid]) || create(info)
      end
    end
  end
end
