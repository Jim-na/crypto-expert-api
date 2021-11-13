# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Binance API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_bn
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save project from Binance to database' do

      majorpair = CryptoExpert::Binance::MajorPairMapper.new('token').get(SYMBOL)

      rebuilt = CryptoExpert::Repository::For.klass(CryptoExpert::Entity::MajorPair).db_find_or_create(majorpair)

      _(rebuilt.symbol).must_equal(majorpair.symbol)
      _(rebuilt.spot_volume).must_equal(majorpair.spot_volume)
      _(rebuilt.future_volume).must_equal(majorpair.future_volume)
      _(rebuilt.funding_rate).must_equal(majorpair.funding_rate)
      _(rebuilt.open_interest).must_equal(majorpair.open_interest)
      _(rebuilt.longshort_ratio).must_equal(majorpair.longshort_ratio)
      
    end
  end
end