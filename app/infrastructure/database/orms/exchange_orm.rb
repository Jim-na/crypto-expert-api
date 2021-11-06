# frozen_string_literal: true

require 'sequel'

module CryptoExpert
  module Database
    # Object-Relational Mapper for Members
    class ExchangeOrm < Sequel::Model(:exchanges)
      one_to_many :record,
                   class: :'CryptoExpert::Database::RecordOrm',
                   key: :id
                   
      plugin :timestamps, update_on_create: true

      def self.find_or_create(exchange_info)
        first(exchangename: exchange_info[:exchangename]) || create(exchange_info)
      end
    end
  end
end
