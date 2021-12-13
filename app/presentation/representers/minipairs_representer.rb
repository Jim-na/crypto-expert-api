# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'minipair_representer'
require_relative 'openstruct_with_links'

module CryptoExpert
  module Representer
    # Represents list of minipairs for API output
    class MiniPairList < Roar::Decorator
      include Roar::JSON

      collection :minipairs, extend: Representer::MiniPair,
                             class: Response::OpenStructWithLinks
    end
  end
end
