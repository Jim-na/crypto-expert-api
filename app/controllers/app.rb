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

      routing.on 'spot' do
        routing.is do
          # POST /project/
          routing.post do
            symbol = routing.params['symbol'].to_s
            # routing.halt 400 unless (gh_url.include? 'github.com') &&
            #                         (gh_url.split('/').count >= 3)
            # owner, project = gh_url.split('/')[-2..]
            routing.redirect "spot/#{symbol}"
          end
        end

        routing.on String do |symbol|
          # GET /project/owner/project
          routing.get do
            spotpair = CryptoExpert::Binance::SpotPairMapper
              .new('token')
              .get(symbol)
            futurepair =  CryptoExpert::Binance::FuturePairMapper
              .new(BINANCE_TOKEN)
              .get(symbol)

            view 'spot', locals: { spot: spotpair , future:futurepair }
            # view 'spot'
          end
        end
        
      end
    end
  end
end
