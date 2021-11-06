# frozen_string_literal: true

require 'sequel'

module CryptoExpert
  module Database
    # Object-Relational Mapper for Members
    class RecordOrm < Sequel::Model(:records)
      many_to_one :exchange,
                   class: :'CryptoExpert::Database::ExchangeOrm'
            
      
      many_to_one :spotpair,
                   class: :'CryptoExpert::Database::SpotOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(record_info)
        first(exchange_id: record_info[:exchange_id], spot_id: record_info[:spot_id]) || create(record_info)
      end
    end
  end
end