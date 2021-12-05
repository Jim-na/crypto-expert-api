# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
require_relative '../../helpers/vcr_helper'

describe 'Tests Binance API library' do
  VcrHelper.setup_vcr
  before do
    VcrHelper.configure_vcr_for_bn(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Temp Mini Pair get information' do
    before do
      @tempminipair = CryptoExpert::Binance::TempMiniPairMapper.new(BINANCE_API_KEY).get(MAJOR_SYMBOL)
    end
    it 'HAPPY: should get Temp Mini CurrencyPair' do
      _(@tempminipair).must_be_kind_of CryptoExpert::Entity::TempMiniPair
    end
    it 'HAPPY: should get Temp Mini CurrencyPair symbol' do
      _(@tempminipair.symbol).wont_be_nil
      _(@tempminipair.symbol).must_equal MAJOR_SYMBOL
    end
    it 'HAPPY: should get Temp Mini CurrencyPair spot volume' do
      _(@tempminipair.spot_volume).wont_be_nil
    end
    it 'HAPPY: should get Temp Mini CurrencyPair future volume' do
      _(@tempminipair.future_volume).wont_be_nil
    end
    it 'HAPPY: should get Temp Mini CurrencyPair funding rate' do
      _(@tempminipair.funding_rate).wont_be_nil
    end
    it 'HAPPY: should get Temp Mini CurrencyPair open interest' do
      _(@tempminipair.open_interest).wont_be_nil
    end
    it 'HAPPY: should get Temp Mini CurrencyPair longshort ratio' do
      _(@tempminipair.longshort_ratio).wont_be_nil
    end
    it 'SAD: should raise exception on notfound currency pair' do
      _(proc do
        CryptoExpert::Binance::TempMiniPairMapper.new(BINANCE_API_KEY).get('TINAJIMBO')
      end).must_raise CryptoExpert::HttpApi::Response::BadRequest
    end
  end
end
