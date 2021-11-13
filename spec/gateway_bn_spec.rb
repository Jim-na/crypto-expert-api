# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'
describe 'Tests Binance API library' do
  VcrHelper.setup_vcr
  before do
    VcrHelper.configure_vcr_for_bn
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Major Pair get information' do
    before do
      @majorpair = CryptoExpert::Binance::MajorPairMapper.new(BINANCE_API_KEY).get(SYMBOL)
    end
    it 'HAPPY: should get Major CurrencyPair' do
      _(@majorpair).must_be_kind_of CryptoExpert::Entity::MajorPair
    end
    it 'HAPPY: should get Major CurrencyPair symbol' do
      _(@majorpair.symbol).wont_be_nil
      _(@majorpair.symbol).must_equal SYMBOL
    end
    it 'HAPPY: should get Major CurrencyPair spot volume' do
      _(@majorpair.price).wont_be_nil
    end
    it 'SAD: should raise exception on notfound currency pair' do
      _(proc do
        CryptoExpert::Binance::SpotPairMapper.new(BINANCE_API_KEY).get('TINAJIMBO')
      end).must_raise CryptoExpert::HttpApi::Response::BadRequest
    end
  end
end
