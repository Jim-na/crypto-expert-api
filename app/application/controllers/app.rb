# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module CryptoExpert
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/view_html'
    # plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_sort.js'

    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      routing.assets # load CSS and js

      routing.root do
        session[:watching] ||= []
        # puts pairlist
        view 'home'
      end
      routing.on 'kol' do
        view 'home'
      end
      
      routing.on 'majorpair' do
        testpair = Binance::MiniPairMapper.new('ETHUSDT').get
        view 'majorpair', locals: { pair: testpair }
      end
      
      routing.on 'minipair' do
        routing.is do
          # POST /project/
          routing.post do
            input = {symbol: routing.params['symbol'].upcase}
            symbol_request = Forms::NewSymbol.new.call(input)
            # Find minipair from database
            minipair = Repository::For.klass(Entity::TempMiniPair).find_symbol(symbol_request[:symbol])
            unless minipair
              minipair_made = Service::AddMiniPair.new.call(symbol_request[:symbol])
              if minipair_made.failure?
                flash[:error] = minipair_made.failure
                routing.redirect '/'
              end
              minipair = minipair_made.value!
            end
            # Still got bug when under "/minipair" to search another pair??
            session[:watching].insert(0, minipair.symbol).uniq!
            puts session[:watching]
            routing.redirect "minipair/#{symbol_request[:symbol]}"
          end

          routing.get do
            puts session[:watching]
            viewable_minipairs_made = Service::ListMiniPairs.new.call(session[:watching])
            if viewable_minipairs_made.failure?
              flash[:error] = viewable_minipairs_made.failure
              routing.redirect '/'
            end
            viewable_minipairs = viewable_minipairs_made.value!
            view 'minipair_index', locals: { pairlist: viewable_minipairs }
          end
        end

        routing.on String do |symbol|
          routing.delete do
            session[:watching].delete(symbol)
            routing.redirect '/'
          end
          # GET /minipair/{symbol}
          routing.get do
            minipair = Repository::For.klass(Entity::TempMiniPair)
              .find_symbol(symbol)
            view 'minipair', locals: { pair: minipair }
          end
        end
      end
    end
  end
end
