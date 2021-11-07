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
      routing.root do
        view 'home'
      end

      routing.root do # rubocop:disable Metrics/BlockLength
        exchanges = CryptoExpert::Repository::For.klass(CryptoExpert::Entity::ExchangeInfo).all
        view 'home', locals: { exchanges: exchanges }
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
            puts spotpair
            view 'spot', locals: { spot: spotpair }

          end
        end
      end
    end
  end
end