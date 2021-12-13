# TODO: write api spec
# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'
require_relative '../../helpers/database_helper'
require 'rack/test'

def app
  CryptoExpert::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_bn(recording: :new_episodes)
    DatabaseHelper.wipe_database
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'Get MiniPair Signal folder route' do
    it 'should be able to POST a Minipair signal' do
        CryptoExpert::Service::GetMiniPairSignal.new.call(MINI_SYMBOL)

      post "/api/v1/minipair/#{MINI_SYMBOL}"
      _(last_response.status).must_equal 201
      result = JSON.parse last_response.body
      _(result['symbol']).wont_be_nil
      _(result['symbol']).must_equal MINI_SYMBOL
      _(result['time']).wont_be_nil
      _(result['volume_change_percent']).wont_be_nil
      _(result['signal']).wont_be_nil
      _(result['spot_volume']).wont_be_nil
      _(result['spot_closeprice']).wont_be_nil
      _(result['funding_rate']).wont_be_nil
      _(result['longshort_ratio']).wont_be_nil
      _(result['open_interest']).wont_be_nil
      _(result['spot_change_percent']).wont_be_nil
    end
  end

  describe 'Get projects list' do
    it 'should successfully return project lists' do
      encoded_list = CryptoExpert::Request::EncodedMiniPairSignalList.to_encoded(["#{MAJOR_SYMBOL}","#{MINI_SYMBOL}"])

      get "/api/v1/minipair?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      pairs = response['minipairs']
      pairs.each do |result|
        _(result['symbol']).wont_be_nil
        _(result['time']).wont_be_nil
        _(result['volume_change_percent']).wont_be_nil
        _(result['signal']).wont_be_nil
        _(result['spot_volume']).wont_be_nil
        _(result['spot_closeprice']).wont_be_nil
        _(result['funding_rate']).wont_be_nil
        _(result['longshort_ratio']).wont_be_nil
        _(result['open_interest']).wont_be_nil
        _(result['spot_change_percent']).wont_be_nil
      end
    end

    it 'should return error if invalid input' do
      list = ['AAA']
      encoded_list = CryptoExpert::Request::EncodedMiniPairSignalList.to_encoded(list)

      get "/api/v1/minipair?list=#{encoded_list}"
      _(last_response.status).must_equal 400
    end

    it 'should return error if not list provided' do
      get '/api/v1/minipair'
      _(last_response.status).must_equal 400

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'list'
    end
  end
end