# frozen_string_literal: true

require 'roda'
require 'slim'

module CryptoExpert
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      # GET /

      routing.root do # rubocop:disable Metrics/BlockLength
        pairlist = CryptoExpert::Repository::For.klass(CryptoExpert::Entity::SpotPair).all
        # puts pairlist
        view 'home', locals: { pairlist: pairlist }
      end

      routing.on 'spot' do
        routing.is do
          # POST /project/
          routing.post do
            symbol = routing.params['symbol'].upcase
            # Get pair from Binance
            spotPair = CryptoExpert::Binance::SpotPairMapper
              .new('token')
              .get(symbol)

            # Add project to database
            CryptoExpert::Repository::For.klass(CryptoExpert::Entity::SpotPair).db_find_or_create(spotPair)

            # Redirect viewer to project page
            routing.redirect "spot/#{symbol}"
          end
        end

        routing.on String do |symbol|
          # GET /project/owner/project
          routing.get do
            spotpair = CryptoExpert::Repository::For.klass(CryptoExpert::Entity::SpotPair)
                       .find_symbol(symbol)
            view 'spot', locals: { spot: spotpair }

          end
        end
      end
    end
  end
end