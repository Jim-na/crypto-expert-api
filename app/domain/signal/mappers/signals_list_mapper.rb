# frozen_string_literal: false

require_relative 'minipair_mapper'
require_relative 'yml_to_pairlist'

module CryptoExpert
  module Binance
    # map the Spot Pair info
    class SignalsListMapper
      # extend SignalCalculator
      def initialize
        #   @minipair_mapper = CryptoExpert::Binance::MiniPairMapper
        @calculator = CryptoExpert::Binance::SignalSort
      end

      def get_sortlist
        symbol_list = Yml2Pairlist.new().pairlist
        SignalsListMapper.build_entity(symbol_list)
      end

      def self.build_entity(symbol_list)
        DataMapper.new(symbol_list).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(symbol_list)
          @data = symbol_list
          # @minipair_mapper = minipair_mapper
          @calculator = CryptoExpert::Binance::SignalSort
        end

        def build_entity
          Entity::SignalsList.new(
            signals: signals
          )
        end

        private
        
        # def minipairs
        #   @data.map do |symbol|
        #     MiniPairMapper.new(symbol).get
        #   end
        # end
        
        def signals
          minipairs = @data.map do |symbol|
            MiniPairMapper.new(symbol).get
          end
          # puts @calculator
          @calculator.new(minipairs).get_list
        end

      end
    end
  end
end
# SignalsListMapper.new().get_sortlist(['BTCUSDT'])
# b =  MiniPairMapper.new('ETHUSDT').get;a = MiniPairMapper.new('BTCUSDT').get; c = MiniPairMapper.new('SOLUSDT').get;l = [a,b,c]
