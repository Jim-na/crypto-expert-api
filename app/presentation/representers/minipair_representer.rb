# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'tempminipair_representer'

# Represents essential Repo information for API output
module CryptoExpert
  module Representer
    # Represent a Project entity as Json
    class MiniPair < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :symbol
      property :increase_percent
      property :signal
      property :time
      property :volume_now

      link :self do
        "#{App.config.API_HOST}/api/v1/minipair/#{symbol}"
      end

      private

      def symbol
        represented.symbol
      end

    end
  end
end
