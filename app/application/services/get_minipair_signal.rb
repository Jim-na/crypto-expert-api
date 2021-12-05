# frozen_string_literal: true

require 'dry/transaction'

module CryptoExpert
  module Service
    # Transaction to store project from Github API to database
    class GetMiniPairSignal
      include Dry::Transaction

      step :get_tempminipair
      step :store_tempminipair
      step :get_minipair_signal

      private
      
      DB_ERR_MSG = 'Could not add tempminipair into database'
      BN_NOT_FOUND_MSG = 'Could not find this pair on Binance'
      SIGNAL_ERR_MSG = 'Could not get the signal of this symbol'

      def get_tempminipair(input)
        tempminipair = Binance::TempMiniPairMapper
        .new(App.config.BINANCE_API_KEY)
        .get(input)
        
        Success(tempminipair)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :not_found, message: BN_NOT_FOUND_MSG))
        # Failure('Could not find this pair')
      end

      def store_tempminipair(input)
        tempminipair = Repository::For.klass(Entity::TempMiniPair).db_find_or_create(input)
        Success(tempminipair)
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end
      
      def get_minipair_signal(input)
        symbol = input.symbol
        minipair = Binance::MiniPairMapper.new(symbol).get
        Success(Response::ApiResult.new(status: :created, message: minipair))
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: SIGNAL_ERR_MSG))
      end
      
    end
  end
end