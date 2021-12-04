# frozen_string_literal: false

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/database_helper'
require_relative '../../helpers/vcr_helper'

describe 'Integration Tests of Binance API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_bn(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save MajorPair from Binance to database' do
      tempmajorpair = CryptoExpert::Binance::TempMajorPairMapper.new('token').get(MAJOR_SYMBOL)

      rebuilt = CryptoExpert::Repository::For.klass(CryptoExpert::Entity::TempMajorPair).db_find_or_create(tempmajorpair)

      _(rebuilt.symbol).must_equal(tempmajorpair.symbol)
      _(rebuilt.spot_volume).must_equal(tempmajorpair.spot_volume)
      _(rebuilt.future_volume).must_equal(tempmajorpair.future_volume)
      _(rebuilt.funding_rate).must_equal(tempmajorpair.funding_rate)
      _(rebuilt.open_interest).must_equal(tempmajorpair.open_interest)
      _(rebuilt.longshort_ratio).must_equal(tempmajorpair.longshort_ratio)

      result = CryptoExpert::Repository::TempMajorPairs.find_symbol(MAJOR_SYMBOL)
      _(rebuilt.symbol).must_equal(result.symbol)
      _(rebuilt.spot_volume).must_equal(result.spot_volume)
      _(rebuilt.future_volume).must_equal(result.future_volume)
      _(rebuilt.funding_rate).must_equal(result.funding_rate)
      _(rebuilt.open_interest).must_equal(result.open_interest)
      _(rebuilt.longshort_ratio).must_equal(result.longshort_ratio)
    end

    it 'HAPPY: should be able to save MiniPair from Binance to database' do
      tempminipair = CryptoExpert::Binance::TempMiniPairMapper.new('token').get(MINI_SYMBOL)

      rebuilt = CryptoExpert::Repository::For.klass(CryptoExpert::Entity::TempMiniPair).db_find_or_create(tempminipair)

      _(rebuilt.symbol).must_equal(tempminipair.symbol)
      _(rebuilt.volume).must_equal(tempminipair.volume)

      result = CryptoExpert::Repository::TempMiniPairs.find_symbol(MINI_SYMBOL)
      _(rebuilt.symbol).must_equal(result.symbol)
      _(rebuilt.volume).must_equal(result.volume)
    end
  end
end
