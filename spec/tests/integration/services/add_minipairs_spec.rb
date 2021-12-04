# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

require 'ostruct'

describe 'AddMiniPairs Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_bn(recording: :new_episodes)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Add a MiniPair' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should get and store a minipair' do
      # GIVEN: a valid project that exists locally and is being watched
      result = CryptoExpert::Service::AddMiniPair.new.call(MINI_SYMBOL)

      tempminipair = CryptoExpert::Binance::TempMiniPairMapper.new(BINANCE_API_KEY).get(MINI_SYMBOL)
      db_tempminipair = CryptoExpert::Repository::For.entity(tempminipair).find_symbol(MINI_SYMBOL)

      # THEN: we should store symbol
      _(result.success?).must_equal true
      _(tempminipair).must_equal db_tempminipair
    end
    it 'SAD: should not get and store a non exist minipair' do
      # GIVEN: a valid project that exists locally and is being watched
      result = CryptoExpert::Service::AddMiniPair.new.call("TINAJIMBO")

      # THEN: we should store symbol
      _(result.success?).must_equal false
    end
  end
end