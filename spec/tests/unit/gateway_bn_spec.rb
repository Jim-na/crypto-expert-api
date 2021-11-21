# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Tests Binance API library' do
  VcrHelper.setup_vcr
  before do
    VcrHelper.configure_vcr_for_bn
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Temp Major Pair get information' do
    before do
      @tempmajorpair = CryptoExpert::Binance::TempMajorPairMapper.new(BINANCE_API_KEY).get(MAJOR_SYMBOL)
    end
    it 'HAPPY: should get Temp Major CurrencyPair' do
      _(@tempmajorpair).must_be_kind_of CryptoExpert::Entity::TempMajorPair
    end
    it 'HAPPY: should get Temp Major CurrencyPair symbol' do
      _(@tempmajorpair.symbol).wont_be_nil
      _(@tempmajorpair.symbol).must_equal MAJOR_SYMBOL
    end
    it 'HAPPY: should get Temp Major CurrencyPair spot volume' do
      _(@tempmajorpair.spot_volume).wont_be_nil
    end
    it 'HAPPY: should get Temp Major CurrencyPair future volume' do
      _(@tempmajorpair.future_volume).wont_be_nil
    end
    it 'HAPPY: should get Temp Major CurrencyPair funding rate' do
      _(@tempmajorpair.funding_rate).wont_be_nil
    end
    it 'HAPPY: should get Temp Major CurrencyPair open interest' do
      _(@tempmajorpair.open_interest).wont_be_nil
    end
    it 'HAPPY: should get Temp Major CurrencyPair longshort ratio' do
      _(@tempmajorpair.longshort_ratio).wont_be_nil
    end
    it 'SAD: should raise exception on notfound currency pair' do
      _(proc do
        CryptoExpert::Binance::TempMajorPairMapper.new(BINANCE_API_KEY).get('TINAJIMBO')
      end).must_raise CryptoExpert::HttpApi::Response::BadRequest
    end
  end

  describe 'Temp Mini Pair get information' do
    before do
      @tempminipair = CryptoExpert::Binance::TempMiniPairMapper.new(BINANCE_API_KEY).get(MINI_SYMBOL)
    end
    it 'HAPPY: should get Temp Mini CurrencyPair' do
      _(@tempminipair).must_be_kind_of CryptoExpert::Entity::TempMiniPair
    end
    it 'HAPPY: should get Temp Mini CurrencyPair symbol' do
      _(@tempminipair.symbol).wont_be_nil
      _(@tempminipair.symbol).must_equal MINI_SYMBOL
    end
    it 'HAPPY: should get Temp Mini CurrencyPair time' do
      _(@tempminipair.time).wont_be_nil
    end
    it 'HAPPY: should get Temp Mini CurrencyPair volume' do
      _(@tempminipair.volume).wont_be_nil
    end
    it 'SAD: should raise exception on notfound currency pair' do
      _(proc do
        CryptoExpert::Binance::TempMiniPairMapper.new(BINANCE_API_KEY).get('TINAJIMBO')
      end).must_raise CryptoExpert::HttpApi::Response::BadRequest
    end
  end
end
