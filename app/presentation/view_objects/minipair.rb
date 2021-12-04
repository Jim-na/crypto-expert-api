# frozen_string_literal: true

module Views
  # View for a single project entity
  class MiniPair
    def initialize(minipair, index = nil)
      @minipair = minipair
      @index = index
    end

    def entity
      @minipair
    end

    def praise_link
      "/minipair/#{symbol}"
    end

    def index_str
      "minipair[#{@index}]"
    end

    def symbol
      @minipair.symbol
    end

    def time
      timestamp = @minipair.time
      Time.at(timestamp / 1000).utc.to_datetime
    end

    def volume_now
      @minipair.volume_now
    end

    def volume_change_24h
      0.0
    end
    
    def increase_percent
      @minipair.increase_percent
    end

    def signal
      @minipair.signal
    end
    # TODO: price movement direction
  end
end
