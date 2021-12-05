# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module CryptoExpert
  module Representer
    # Represents essential Member information for API output
    # USAGE:
    #   member = Database::MemberOrm.find(1)
    #   Representer::Member.new(member).to_json
    class TempMiniPair < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer
      property :symbol
      property :time
      property :spot_volume     
      property :future_volume   
      property :funding_rate    
      property :longshort_ratio 
      property :open_interest   
      property :spot_closeprice 
      
      link :self do
        "#{App.config.API_HOST}/api/v1/tempminipair/#{symbol}"
      end
      
      private

      def symbol
        represented.symbol
      end
      
    end
  end
end
