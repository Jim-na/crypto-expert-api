# frozen_string_literal: true

require 'sequel'

module CryptoExpert
  module Database
    # Object-Relational Mapper for Members
    class ExchangeOrm < Sequel::Model(:exchanges)
      one_to_many :spotpair,
                  class: :'CryptoExpert::Database::SpotOrm',
                  key: :id

      one_to_many :currencylist,
                  class: :'CryptoExpert::Database::CurrencyListOrm',
                  key: :id
      one_to_many :fundingratelist,
                  class: :'CryptoExpert::Database::FundingRateListOrm',
                  key: :id
      plugin :timestamps, update_on_create: true

      def self.find_or_create(exchange_info)
        first(exchangename: exchange_info[:exchangename]) || create(exchange_info)
      end
    end
  end
end
