# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

require 'ostruct'

describe 'ListMiniPairs Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_bn(recording: :new_episodes)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'List MiniPairs' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return minipairs that are being watched' do
      # GIVEN: a valid project exists locally and is being watched
      tempminipair = CryptoExpert::Binance::TempMiniPairMapper.new(BINANCE_API_KEY).get(MINI_SYMBOL)
      CryptoExpert::Repository::For.klass(CryptoExpert::Entity::TempMiniPair).db_find_or_create(tempminipair)
      db_tempminipair = CryptoExpert::Repository::For.entity(tempminipair).find_symbol(MINI_SYMBOL)
      minipair = CryptoExpert::Binance::MiniPairMapper.new(MINI_SYMBOL).get

      # WHEN: we request a list of all watched projects
      list_req = CryptoExpert::Request::EncodedMiniPairSignalList.to_request(["#{MAJOR_SYMBOL}","#{MINI_SYMBOL}"])
      result = CryptoExpert::Service::ListMiniPairs.new.call(list_request: list_req)

      # THEN: we should see our project in the resulting list
      _(result.success?).must_equal true
      _(result.value!.message.minipairs).must_include minipair
    end

    it 'HAPPY: should not return projects that are not being watched' do
      # GIVEN: a valid project exists locally and is being watched
      tempminipair = CryptoExpert::Binance::TempMiniPairMapper.new(BINANCE_API_KEY).get(MINI_SYMBOL)
      CryptoExpert::Repository::For.klass(CryptoExpert::Entity::TempMiniPair).db_find_or_create(tempminipair)
      db_tempminipair = CryptoExpert::Repository::For.entity(tempminipair).find_symbol(MINI_SYMBOL)
      minipair = CryptoExpert::Binance::MiniPairMapper.new(MINI_SYMBOL).get

      # WHEN: we request a list of all watched projects
      list_req = CryptoExpert::Request::EncodedMiniPairSignalList.to_request([])
      result = CryptoExpert::Service::ListMiniPairs.new.call(list_request: list_req)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      _(result.value!.message.minipairs).must_equal []
    end
  end
end