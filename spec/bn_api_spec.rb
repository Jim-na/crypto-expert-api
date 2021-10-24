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

  describe 'CurrencyPair list' do
    it 'HAPPY: should provide correct currencyPair list' do
      info = CryptoExpert::InfoApi.new('token')
      _(info.currencypair_list).must_equal CORRECT['symbols']
    end
  end

  describe 'CurrencyPair get information' do
    before do
      @currencypair = CryptoExpert::InfoApi.new('token').currencypair(SYMBOL)
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
        CryptoExpert::InfoApi.new('token').currencypair('BTCETH')
      end).must_raise CryptoExpert::HttpApi::Response::BadRequest
    end
  end
end
