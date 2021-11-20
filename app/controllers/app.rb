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
                    css: 'style.css', js:'table_sort.js'
    
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
        view 'home'
      end
      routing.on 'minipair' do
        routing.is do
          # POST /project/
          routing.post do
            symbol = routing.params['symbol'].upcase
            # Add minipair to database
            minipair = Repository::For.klass(Entity::TempMiniPair).find_symbol(symbol)
            if minipair
              begin
                # Get pair from Binance
                minipair = Binance::TempMiniPairMapper
                          .new(App.config.BINANCE_API_KEY)
                          .get(symbol)
                session[:watching].insert(0, minipair.symbol).uniq!
              rescue
                flash[:error] = 'Could not find that this pair'
                routing.redirect '/'
              end
              # Add minipair to database
              begin
                Repository::For.klass(Entity::TempMiniPair).db_find_or_create(minipair)
              rescue StandardError => err
                puts err.backtrace.join("\n")
                flash[:error] = 'Having trouble accessing the database'
              end
            end
            # Still got bug when under "/minipair" to search another pair??
            # begin
            #   session[:watching].insert(0, minipair.symbol).uniq!
            # rescue
            #   flash[:error] = 'Having trouble accessing the cookies'
            # end
            puts session[:watching]
            routing.redirect "minipair/#{symbol}"
          end
          
          routing.get do
            # minipairs = Repository::For.klass(Entity::TempMiniPair).all()
            puts session[:watching]
            begin
              minipairs = session[:watching].map{|pair| 
                          Repository::For.klass(Entity::TempMiniPair).find_symbol(pair)}
            rescue StandardError => err
              puts err.backtrace.join("\n")
              flash[:error] = 'Add a Mini Pair to get started'
              routing.redirect '/'
            end
            begin
              viewable_minipairs = Views::MiniPairList.new(minipairs) 
            rescue StandardError => err
              puts err.backtrace.join("\n")
              flash[:error] = 'Add a Mini Pair to get started'
              viewable_minipairs = []
            end
            
            # session[:watching] = minipairs.map{|pair| pair.symbol}
            view 'minipair_index', locals: { pairlist: viewable_minipairs }
          end
        end

        routing.on String do |symbol|
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
