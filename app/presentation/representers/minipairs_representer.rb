# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'minipair_representer'

module CryptoExpert
  module Representer
    # Represents list of minipairs for API output
    class MiniPairList < Roar::Decorator
      include Roar::JSON

      collection :minipairs, extend: Representer::MiniPair
    end
  end
end
