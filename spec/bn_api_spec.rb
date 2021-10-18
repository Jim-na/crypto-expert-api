# frozen_string_literal: true

require  'minitest/autorun'
require  'minitest/rg'
require  'yaml'
require_relative '../lib/binance_api'

CORRECT = YAML.safe_load(File.read('fixtures/results.yml'))
SYMBOL = 'ETHBTC'
describe 'Tests Binance API library' do
  describe 'CurrencyPair list' do
    it 'HAPPY: should provide correct currencyPair list' do
      binance = CryptoExpert::BinanceApi.new('token')
      _(binance.currencypair_list.size).must_equal CORRECT['symbols'].size
    end
  end

  describe 'CurrencyPair get information' do
    before do
      @currencypair = CryptoExpert::BinanceApi.new('token').currencypair(SYMBOL)
    end
    it 'HAPPY: should get CurrencyPair' do
      _(@currencypair).must_be_kind_of CryptoExpert::CurrencyPair
    end
    it 'HAPPY: should get CurrencyPair symbol' do
      _(@currencypair.symbol).wont_be_nil
      _(@currencypair.symbol).must_equal SYMBOL
    end
    it 'HAPPY: should get CurrencyPair price' do
      _(@currencypair.price).wont_be_nil
    end
    it 'SAD: should raise exception on unfound currency pair' do
      _(proc do
        CryptoExpert::BinanceApi.new('token').currencypair('BTCETH')
      end).must_raise CryptoExpert::BinanceApi::Errors::BadRequest
    end
  end
end
