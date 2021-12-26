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

      NO_PAIR_ERR = 'Add a Mini Pair to get started'
      

      # Expects list of movies in input[:list_request]
      def validate_list(input)
        puts "hi",input
        list_request = input[:list_request].call
        puts "hi2",list_request.value!
        if list_request.success?
          Success(input.merge(list: list_request.value!))
        else
          Failure(list_request.failure)
        end
      end

      def list_minipair_signal(input)
        list = input[:list]
        
        minipairs = Binance::SignalsListMapper.new().get_sortlist(list).signals
        minipairs.then { |minipairs| Response::MinipairsList.new(minipairs) }
            .then { |list| Response::ApiResult.new(status: :ok, message: list) }
            .then { |result| Success(result) }
        # list.map do |pair|
        # #   Binance::MiniPairMapper.new(pair).get
        #     SignalsListMapper.new().get_sortlist(pair)
        # end
          
        # Success(Response::ApiResult.new(status: :created, message: minipairs.signals ))
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :bad_request, message: NO_PAIR_ERR))
      end

    end
  end
end
