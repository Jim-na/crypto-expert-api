# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# require_relative 'openstruct_with_links'
require_relative 'minipair_representer'

module CryptoExpert
  module Representer
    # Represents list of projects for API output
    class MiniPairList < Roar::Decorator
      include Roar::JSON

      collection :minipair_signal, extend: Representer::MiniPair
    end
  end
end
