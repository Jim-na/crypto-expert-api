# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Tests Binance API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    # c.filter_sensitive_data('<GITHUB_TOKEN>') { GITHUB_TOKEN }
    # c.filter_sensitive_data('<GITHUB_TOKEN_ESC>') { CGI.escape(GITHUB_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTES_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end
  
  
  describe 'Exchange info' do
    before do
      @info = CryptoExpert::Binance::ExchangeMapper.new(BINANCE_TOKEN).get()
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
  describe 'Future Pair get information' do
    before do
      @futurepair = CryptoExpert::Binance::FuturePairMapper.new(BINANCE_TOKEN).get(SYMBOL)
    end
    it 'HAPPY: should get Future CurrencyPair' do
      _(@futurepair).must_be_kind_of CryptoExpert::Entity::FuturePair
    end
    it 'HAPPY: should get Future CurrencyPair symbol' do
      _(@futurepair.symbol).wont_be_nil
      _(@futurepair.symbol).must_equal SYMBOL
    end
    it 'HAPPY: should get Future CurrencyPair price' do
      _(@futurepair.price).wont_be_nil
    end
    it 'SAD: should raise exception on notfound currency pair' do
      _(proc do
        CryptoExpert::Binance::FuturePairMapper.new(BINANCE_TOKEN).get('TINAJIMBO')
      end).must_raise CryptoExpert::HttpApi::Response::BadRequest
    end
  end
  
  
end
