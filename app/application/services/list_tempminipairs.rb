# frozen_string_literal: true

require 'dry/monads'

module CryptoExpert
  module Service
    # Retrieves array of all listed project entities
    class ListTempMiniPairs
      include Dry::Transaction

      step :list_minipair
      step :view_minipair

      private

      def list_minipair(input)
        minipairs = input.map do |pair|
          Repository::For.klass(Entity::TempMiniPair).find_symbol(pair)
        end.compact

        Success(minipairs)
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure('Add a Mini Pair to get started')
      end

      def view_minipair(input)
        viewable_minipairs = Views::MiniPairList.new(input)

        Success(viewable_minipairs)
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure('Can not make viewable pairs')
      end
    end
  end
end
