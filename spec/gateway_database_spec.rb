# frozen_string_literal: false

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'

describe 'Integration Tests of Binance API and Database' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_github
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to save project from Github to database' do
      spotPair = CryptoExpert::Binance::SpotPairMapper
        .new('token')
        .get(symbol)

      rebuilt = CodePraise::Repository::For.entity(project).create(spotPair)

      _(rebuilt.symbol).must_equal(spotPair.symbol)
      _(rebuilt.price).must_equal(spotPair.price)
      _(rebuilt.exchange).must_equal(project.exchange)

    end
  end
end