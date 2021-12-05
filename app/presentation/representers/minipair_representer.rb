# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents essential MiniPair signal information for API output
module CryptoExpert
  module Representer
    # Represent a MiniPair entity as Json
    class MiniPair < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :symbol
      property :volume_change_percent
      property :signal
      property :time
      property :spot_volume
      property :spot_closeprice
      property :funding_rate
      property :longshort_ratio
      property :open_interest
      property :spot_change_percent

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
