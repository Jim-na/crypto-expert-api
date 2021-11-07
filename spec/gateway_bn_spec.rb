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

  describe 'Exchange info' do
    before do
      @info = CryptoExpert::Binance::ExchangeMapper.new(BINANCE_TOKEN).get
    end
    it 'HAPPY: should provide correct currencyPair list' do
      _(@info.currencylist).must_equal CORRECT['symbols']
    end
    it 'HAPPY: should provide correct funding rate list' do
      _(@info.fundingratelist).must_equal CORRECT['fundingRate']
    end
    it 'HAPPY: should provide correct funding rate list' do
      _(@info.timezone).must_equal CORRECT['timezone']
    end
  end

  describe 'Spot Pair get information' do
    before do
      @spotpair = CryptoExpert::Binance::SpotPairMapper.new(BINANCE_TOKEN).get(SYMBOL)
    end
    it 'HAPPY: should get Spot CurrencyPair' do
      _(@spotpair).must_be_kind_of CryptoExpert::Entity::SpotPair
    end
    it 'HAPPY: should get Spot CurrencyPair symbol' do
      _(@spotpair.symbol).wont_be_nil
      _(@spotpair.symbol).must_equal SYMBOL
    end
    it 'HAPPY: should get Spot CurrencyPair price' do
      _(@spotpair.price).wont_be_nil
    end
    it 'SAD: should raise exception on notfound currency pair' do
      _(proc do
        CryptoExpert::Binance::SpotPairMapper.new(BINANCE_TOKEN).get('TINAJIMBO')
      end).must_raise CryptoExpert::HttpApi::Response::BadRequest
    end
  end
end
