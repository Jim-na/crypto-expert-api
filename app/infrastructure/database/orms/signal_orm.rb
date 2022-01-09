# frozen_string_literal: true

require 'sequel'

module CryptoExpert
  module Database
    # Object-Relational Mapper for Members
    class SignalOrm < Sequel::Model(:signal)
      plugin :timestamps, update_on_create: true
      
      def self.create(info)
        first(symbol: info[:symbol]){time > Time.now.to_i - 14400000} || create(info)
      end

    end
  end
end
