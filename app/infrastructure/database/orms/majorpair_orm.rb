# frozen_string_literal: true

require 'sequel'

module CryptoExpert
  module Database
    # Object-Relational Mapper for Members
    class TempMajorPairOrm < Sequel::Model(:tempmajorpair)
      plugin :timestamps, update_on_create: true

      def self.find_or_create(info)
        first(symbol: info[:symbol]) || create(info)
      end
    end
  end
end
