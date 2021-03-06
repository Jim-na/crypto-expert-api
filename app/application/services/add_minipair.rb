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

      DB_ERR_MSG = 'Could not add minipair into database'
      BN_NOT_FOUND_MSG = 'Could not find this pair on Binance'

      def get_minipair(input)
        minipair = Binance::TempMiniPairMapper
          .new(App.config.BINANCE_API_KEY)
          .get(input)

        Success(minipair)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :not_found, message: BN_NOT_FOUND_MSG))
        # Failure('Could not find this pair')
      end

      def store_minipair(input)
        tempminipair = Repository::For.klass(Entity::TempMiniPair).db_find_or_create(input)
        Success(Response::ApiResult.new(status: :created, message: tempminipair))
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end
    end
  end
end
