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

      _(rebuilt.symbol).must_equal(spotPair.symbol)
      _(rebuilt.price).must_equal(spotPair.price)

    end
  end
end