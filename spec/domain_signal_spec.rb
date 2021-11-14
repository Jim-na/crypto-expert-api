# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
describe 'Tests Domain Entity' do
  VcrHelper.setup_vcr
  before do
    VcrHelper.configure_vcr_for_bn
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Mini Pair get information' do
    before do
      @minipair = CryptoExpert::Binance::MiniPairMapper.new(MINI_SYMBOL).get()
    end
    it 'HAPPY: should get Mini CurrencyPair' do
      _(@minipair).must_be_kind_of CryptoExpert::Entity::MiniPair
    end
    it 'HAPPY: should get Mini CurrencyPair symbol' do
      _(@minipair.symbol).wont_be_nil
      _(@minipair.symbol).must_equal MINI_SYMBOL
    end
    it 'HAPPY: should get Mini CurrencyPair time' do
      _(@minipair.increase_percent).wont_be_nil
    end
    it 'SAD: should raise exception on notfound currency pair' do
      _(proc do
        CryptoExpert::Binance::MiniPairMapper.new(BINANCE_API_KEY).get('TINAJIMBO')
      end).must_raise CryptoExpert::HttpApi::Response::BadRequest
    end
  end
end
