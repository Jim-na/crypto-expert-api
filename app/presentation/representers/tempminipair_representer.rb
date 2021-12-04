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

      property :symbol
      property :time
      property :volume
    end
  end
end
