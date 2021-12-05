# frozen_string_literal: true

require 'dry/monads'

module CryptoExpert
  module Service
    # Retrieves array of all listed minipair signal entities
    class ListMiniPairs
      include Dry::Transaction

      step :validate_list
      step :list_minipair_signal
      # step :view_minipair

      private

      NO_PAIR_ERR = 'Add a Mini Pair to get started'
      VIEW_PAIR_ERR = 'Can not make viewable pairs'

      # Expects list of movies in input[:list_request]
      def validate_list(input)
        puts input
        list_request = input[:list_request].call
        puts 'list req', list_request.value!
        if list_request.success?
          Success(input.merge(list: list_request.value!))
        else
          Failure(list_request.failure)
        end
      end

      def list_minipair_signal(input)
        list = input[:list]
        list.map do |pair|
          Binance::MiniPairMapper.new(pair).get
        end
          .then { |minipairs| Response::MinipairsList.new(minipairs) }
          .then { |list| Response::ApiResult.new(status: :ok, message: list) }
          .then { |result| Success(result) }
        # Success(Response::ApiResult.new(status: :created, message: minipairs))
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :bad_request, message: NO_PAIR_ERR))
      end

      def view_minipair(input)
        viewable_minipairs = Views::MiniPairList.new(input)
        Success(Response::ApiResult.new(status: :created, message: viewable_minipairs))
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: VIEW_PAIR_ERR))
      end
    end
  end
end
