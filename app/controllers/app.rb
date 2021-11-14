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
      routing.on 'kol' do
        view 'home'
      end
      routing.on 'majorpair' do
        view 'home'
      end
      routing.on 'minipair' do
        routing.is do
          # POST /project/
          routing.post do
            symbol = routing.params['symbol'].upcase
            # Get pair from Binance
            
            minipair = CryptoExpert::Binance::TempMiniPairMapper
                       .new(App.config.BINANCE_API_KEY)
                       .get(symbol)

            # Add project to database
            Repository::For.klass(Entity::TempMiniPair).db_find_or_create(minipair)

            # Redirect viewer to project page
            routing.redirect "minipair/#{symbol}"
          end
          routing.get do
            minipairs_list = Repository::For.klass(Entity::TempMiniPair).all
            view 'minipair_index', locals: { pairlist: minipairs_list }
          end
        end

        routing.on String do |symbol|
          # GET /project/owner/project
          routing.get do
            # minipair = CryptoExpert::Binance::TempMiniPairMapper
            #            .new(App.config.BINANCE_API_KEY)
            #            .get(symbol)
            minipair = Repository::For.klass(Entity::TempMiniPair)
                                                    .find_symbol(symbol)
            view 'minipair', locals: { pair: minipair }
          end
        end
        
      end
    end
  end
end
