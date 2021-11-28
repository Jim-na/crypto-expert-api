# frozen_string_literal: true

require 'dry/transaction'

module CryptoExpert
  module Service
    # Transaction to store project from Github API to database
    class AddMiniPair
      include Dry::Transaction

      step :get_minipair
      step :store_minipair

      private

      def get_minipair(input)
        minipair = Binance::TempMiniPairMapper
        .new(App.config.BINANCE_API_KEY)
        .get(input)
        
        Success(minipair)
      rescue StandardError
        Failure('Could not find this pair')
      end

      def store_minipair(input)
        tempminipair = Repository::For.klass(Entity::TempMiniPair).db_find_or_create(input)

        Success(tempminipair)
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure('Could not add minipair into database')
      end

    end
  end
end