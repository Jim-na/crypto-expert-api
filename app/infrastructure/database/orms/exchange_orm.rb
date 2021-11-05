# frozen_string_literal: true

require 'sequel'

module CryptoExpert
  module Database
    # Object-Relational Mapper for Members
    class ExchangeOrm < Sequel::Model(:exchanges)
      # many_to_many :spotpair,
      #              class: :'CryptoExpert::Database::SpotOrm',
      #              key: :id
                  
      # one_to_many :futurepair,
      #             class: :'CryptoExpert::Database::FutureOrm',
      #             key: :futures_id
      many_to_many :spotpairs,
                   class: :'CryptoExpert::Database::SpotOrm',
                   join_table: :exchange_spotpair,
                   left_key: :exchange_id, right_key: :spot_id
                   
      plugin :timestamps, update_on_create: true

      def self.find_or_create(exchange_info)
        first(exchangename: exchange_info[:exchangename]) || create(exchange_info)
      end
    end
  end
end
