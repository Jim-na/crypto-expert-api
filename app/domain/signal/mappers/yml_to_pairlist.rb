# frozen_string_literal: false

require 'yaml'

module CryptoExpert
  module Binance
    # map the Spot Pair info
    class Yml2Pairlist
      # extend SignalCalculator
      def initialize
        @list = YAML.safe_load(File.read('app/domain/signal/mappers/pairlist.yml'))
      end

      def pairlist
        @list
      end
      
    end
  end
end

