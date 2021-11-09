# frozen_string_literal: true

require 'sequel'

module CryptoExpert
  module Database
    # Object-Relational Mapper for Members
    class SpotOrm < Sequel::Model(:spots)
      many_to_one :exchange,
                  class: :'CryptoExpert::Database::ExchangeOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(info)
        first(symbol: info[:symbol], exchangeid: info[:exchange]) || create(info)
      end

      def create(info)
        create(info)
      end
    end
  end
end
