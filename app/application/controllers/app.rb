# frozen_string_literal: true

require 'roda'

module CryptoExpert
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # recognizes HTTP verbs beyond GET/POST (e.g., DELETE)
    use Rack::MethodOverride # for other HTTP verbs (with plugin all_verbs)

    route do |routing|
      response['Content-Type'] = 'application/json'
      
      # GET /
      routing.root do
        message = "Crypto-Expert API v1 at /api/v1/ in #{App.environment} mode"

        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end
      
      routing.on 'api/v1' do
        routing.on 'minipair' do       
          routing.on String do |symbol|
            # GET /minipair/{symbol}
            # routing.get do 
            #   path_request = Request::MiniPairPath.new(symbol,request)
            #   # puts "get minitpair ", path_request.symbol
            #   result = Service::AddMiniPair.new.call(requested: path_request)
              
            #   if result.failure?
            #     failed = Representer::HttpResponse.new(result.failure)
            #     routing.halt failed.http_status_code, failed.to_json
            #   end

            #   http_response = Representer::HttpResponse.new(result.value!)
            #   response.status = http_response.http_status_code

            #   Representer::MiniPair.new(
            #     result.value!.message
            #   ).to_json
            # end
            # POST /projects/{owner_name}/{project_name}
            routing.post do
              minipair_made = Service::AddMiniPair.new.call(symbol)

              if minipair_made.failure?
                failed = Representer::HttpResponse.new(minipair_made.failure)
                routing.halt failed.http_status_code, failed.to_json
              end
              puts minipair_made
              puts minipair_made.value!
      
              http_response = Representer::HttpResponse.new(minipair_made.value!)
              puts http_response
              response.status = http_response.http_status_code
              Representer::TempMiniPair.new(minipair_made.value!.message).to_json
            end
          end
          
          # routing.is do
          #   routing.get do
          #     list_req = Request::EncodedMiniPairSignalList.new(routing.params)
          #     result = Service::ListMiniPairs.new.call(list_request: list_req)

          #     if result.failure?
          #       failed = Representer::HttpResponse.new(result.failure)
          #       routing.halt failed.http_status_code, failed.to_json
          #     end

          #     http_response = Representer::HttpResponse.new(result.value!)
          #     response.status = http_response.http_status_code
          #     Representer::MiniPairList.new(result.value!.message).to_json
          #   end
          # end
        end
      end
    end
  end
end 

=begin
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
              routing.redirect "minipair/#{symbol_request[:symbol]}"
            end

            routing.get do
              viewable_minipairs_made = Service::ListTempMiniPairs.new.call(session[:watching])
              if viewable_minipairs_made.failure?
                flash[:error] = viewable_minipairs_made.failure
                routing.redirect '/'
              end
              viewable_minipairs = viewable_minipairs_made.value!
              view 'minipair_index', locals: { pairlist: viewable_minipairs }
            end
          end
=end  