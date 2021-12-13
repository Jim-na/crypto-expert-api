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
        routing.on 'tempminipair' do
          routing.on String do |symbol|
            routing.post do
              minipair_made = Service::AddMiniPair.new.call(symbol)

              if minipair_made.failure?
                failed = Representer::HttpResponse.new(minipair_made.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(minipair_made.value!)
              response.status = http_response.http_status_code
              Representer::TempMiniPair.new(minipair_made.value!.message).to_json
            end
          end
        end

        routing.on 'minipair' do
          # TODO: => DONE: on string => post symbol to get this symbol's signal
          routing.on String do |symbol|
            routing.post do
              minipair_signal = Service::GetMiniPairSignal.new.call(symbol)

              if minipair_signal.failure?
                failed = Representer::HttpResponse.new(minipair_signal.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(minipair_signal.value!)
              response.status = http_response.http_status_code
              Representer::MiniPair.new(minipair_signal.value!.message).to_json
            end
          end
          # TODO: => DONE: GET /minipair => get minipair(signal) list
          # TODO => DONE: so we need a new service to get this list
          routing.is do
            # GET /minipair?list={base64_json_array_of_minipair_symbol}
            routing.get do
              response.cache_control public: true, max_age: 300

              list_req = Request::EncodedMiniPairSignalList.new(routing.params)
              result = Service::ListMiniPairs.new.call(list_request: list_req)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::MiniPairList.new(result.value!.message).to_json
            end
          end
        end
      end
    end
  end
end
