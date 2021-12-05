# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

require 'ostruct'

describe 'GetMinipairSignal Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_bn(recording: :new_episodes)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Get a MiniPair Signal' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should get and store a minipair signal' do
      # GIVEN: a valid project that exists locally and is being watched
      result = CryptoExpert::Service::GetMiniPairSignal.new.call(MINI_SYMBOL)
      tempminipair = CryptoExpert::Binance::TempMiniPairMapper.new(BINANCE_API_KEY).get(MINI_SYMBOL)
      db_tempminipair = CryptoExpert::Repository::For.entity(tempminipair).find_symbol(MINI_SYMBOL)
      minipair = CryptoExpert::Binance::MiniPairMapper.new(MINI_SYMBOL).get
      _(result.success?).must_equal true
      _(result.value!.message).must_equal minipair
    end
    it 'SAD: should not get and store a non exist minipair' do
      # GIVEN: a valid project that exists locally and is being watched
      result = CryptoExpert::Service::AddMiniPair.new.call('TINAJIMBO')

      # THEN: we should store symbol
      _(result.success?).must_equal false
    end
  end
end
