# frozen_string_literal: true

require 'dry/monads'

module CryptoExpert
  module Service
    # Retrieves array of all listed minipair signal entities
    class ListSignalsPairs
      include Dry::Transaction

      step :validate_list
      step :list_minipair_signal
      # step :view_minipair

      private

      NO_PAIR_ERR = "Some pairs can't be found in Binance"

      # Expects list of movies in input[:list_request]
      def validate_list(input)
        list_request = input[:list_request].call
        if list_request.success?
          Success(input.merge(list: list_request.value!))
        else
          Failure(list_request.failure)
        end
      end

      def list_minipair_signal(input)
        list = input[:list]

        minipairs = Binance::SignalsListMapper.new.get_sortlist(list).signals
        minipairs.then { |minipairs| Response::MinipairsList.new(minipairs) }
          .then { |list| Response::ApiResult.new(status: :ok, message: list) }
          .then { |result| Success(result) }
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :bad_request, message: NO_PAIR_ERR))
      end
    end
  end
end
