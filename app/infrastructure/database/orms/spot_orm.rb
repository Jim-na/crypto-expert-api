# frozen_string_literal: true

require 'sequel'

module CryptoExpert
  module Database
    # Object-Relational Mapper for Members
    class SpotOrm < Sequel::Model(:spots)
      one_to_many :exchange,
                  class: :'CryptoExpert::Database::ExchangeOrm',
                  key: :exchanges
        
      many_to_many :spotpairs,
                   class: :'CryptoExpert::Database::ExchangeOrm',
                   join_table: :exchange_spotpair,
                   left_key: :exchange_id, right_key: :spot_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(symbol_name)
        first(symbol: symbol_name[:symbol]) || create(symbol_name)
      end
    end
  end
end
