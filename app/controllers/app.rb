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
        pairlist = CryptoExpert::Repository::For.klass(CryptoExpert::Entity::TempMiniPair).all
        # puts pairlist
        view 'home', locals: { pairlist: pairlist }
      end

      routing.on 'minipair' do
        routing.is do
          # POST /project/
          routing.post do
            symbol = routing.params['symbol'].upcase
            # Get pair from Binance
            
            # spotpair = CryptoExpert::Binance::MajorPairMapper
            #            .new(App.config.BINANCE_API_KEY)
            #            .get(symbol)

            # Add project to database
            # CryptoExpert::Repository::For.klass(CryptoExpert::Entity::MajorPair).db_find_or_create(spotpair)

            # Redirect viewer to project page
            routing.redirect "minipair/#{symbol}"
          end
          routing.get do
            
            view 'minipair_index', locals: { pair: nil }
          end
        end

        routing.on String do |symbol|
          # GET /project/owner/project
          routing.get do
            minipair = CryptoExpert::Binance::TempMiniPairMapper
                       .new(App.config.BINANCE_API_KEY)
                       .get(symbol)
            # spotpair = CryptoExpert::Repository::For.klass(CryptoExpert::Entity::MajorPair)
            #                                         .find_symbol(symbol)
            view 'minipair', locals: { pair: minipair }
          end
        end
        
      end
    end
  end
end
