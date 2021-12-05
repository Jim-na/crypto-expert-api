# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'

describe 'Tests Domain Entity' do
  VcrHelper.setup_vcr
  before do
    VcrHelper.configure_vcr_for_bn(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Mini Pair get information' do
    before do
      @minipair = CryptoExpert::Binance::MiniPairMapper.new(MINI_SYMBOL).get
    end
    it 'HAPPY: should get Mini CurrencyPair' do
      _(@minipair).must_be_kind_of CryptoExpert::Entity::MiniPair
    end
    it 'HAPPY: should get Mini CurrencyPair symbol' do
      _(@minipair.symbol).wont_be_nil
      _(@minipair.symbol).must_equal MINI_SYMBOL
    end
    it 'HAPPY: should get Mini CurrencyPair time' do
      _(@minipair.time).wont_be_nil
    end
    it 'HAPPY: should get Mini CurrencyPair volume_change_percent' do
      _(@minipair.volume_change_percent).wont_be_nil
    end
    it 'HAPPY: should get Mini CurrencyPair signal' do
      _(@minipair.signal).wont_be_nil
    end
    it 'HAPPY: should get Mini CurrencyPair spot_volume' do
      _(@minipair.spot_volume).wont_be_nil
    end
    it 'HAPPY: should get Mini CurrencyPair spot_closeprice' do
      _(@minipair.spot_closeprice).wont_be_nil
    end
    it 'HAPPY: should get Mini CurrencyPair funding_rate' do
      _(@minipair.funding_rate).wont_be_nil
    end
    it 'HAPPY: should get Mini CurrencyPair longshort_ratio' do
      _(@minipair.longshort_ratio).wont_be_nil
    end
    it 'HAPPY: should get Mini CurrencyPair open_interest' do
      _(@minipair.open_interest).wont_be_nil
    end
    it 'HAPPY: should get Mini CurrencyPair spot_change_percent' do
      _(@minipair.spot_change_percent).wont_be_nil
    end
    it 'SAD: should raise exception on notfound currency pair' do
      _(proc do
        CryptoExpert::Binance::MiniPairMapper.new(BINANCE_API_KEY).get('TINAJIMBO')
      end).must_raise CryptoExpert::HttpApi::Response::BadRequest
    end
  end
end
