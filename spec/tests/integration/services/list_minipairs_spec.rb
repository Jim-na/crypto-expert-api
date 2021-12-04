# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

require 'ostruct'

describe 'ListTempMiniPairs Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_bn(recording: :new_episodes)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'List Minipairs' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return minipairs that are being watched' do
      # GIVEN: a valid minipair exists locally and is being watched
      tempminipair = CryptoExpert::Binance::TempMiniPairMapper.new(BINANCE_API_KEY).get(MINI_SYMBOL)
      CryptoExpert::Repository::For.klass(CryptoExpert::Entity::TempMiniPair).db_find_or_create(tempminipair)
      db_tempminipair = CryptoExpert::Repository::For.entity(tempminipair).find_symbol(MINI_SYMBOL)
      tempview = Views::MiniPairList.new([db_tempminipair])
      watched_list = [MINI_SYMBOL]

      # WHEN: we request a list of all watched projects
      result = CryptoExpert::Service::ListTempMiniPairs.new.call(watched_list)
      # THEN: we should see our project in the resulting list
      _(result.success?).must_equal true
      symbol_list = result.value!.list
      _(symbol_list).must_include MINI_SYMBOL
    end

    it 'HAPPY: should not return minipairs that are not being watched' do
      # GIVEN: a valid project exists locally but is not being watched
      tempminipair = CryptoExpert::Binance::TempMiniPairMapper.new(BINANCE_API_KEY).get(MINI_SYMBOL)
      tempview = Views::MiniPairList.new([])
      watched_list = []

      # WHEN: we request a list of all watched projects
      result = CryptoExpert::Service::ListTempMiniPairs.new.call(watched_list)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      symbol_list = result.value!.list
      _(symbol_list).must_equal []
    end
  end
end