# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'
require_relative 'pages/minipair_page'
require_relative 'pages/minipair_index_page'

describe 'Minipair Page Acceptance Tests' do
  include PageObject::PageFactory
  before do
    DatabaseHelper.wipe_database
    # @headless = Headless.new
    @browser = Watir::Browser.new
  end

  after do
    @browser.close
    # @headless.destroy
  end
  describe 'Visit Mini Pair List Page' do
    it '(HAPPY) should get hint when click nav bar minipair' do
        # GIVEN: user is on the home page
        visit MiniPairIndexPage do |page|
            # WHEN: user has not added pair
            # THEN: they should see a warning message
            _(page.warning_message.downcase).must_include 'start'
        end
        
    end
    it '(HAPPY) should not get the request minipair table' do
        # GIVEN: a symbol that in the database but user has not request it
        minipair = CryptoExpert::Binance::TempMiniPairMapper
          .new(CryptoExpert::App.config.BINANCE_API_KEY)
          .get(MINI_SYMBOL)
        CryptoExpert::Repository::For.klass(CryptoExpert::Entity::TempMiniPair).db_find_or_create(minipair)

        # WHEN: user go back to minipair list
        visit MiniPairIndexPage do |page|
            # THEN: they should not see the pair they didn't enter
            _(page.pairtable_element.exist?).must_equal false
        end
    end
  end
  describe 'Visit Mini pair page' do
    it '(HAPPY) should get minipair volume & time' do
        # GIVEN: A minipair exist
        minipair = CryptoExpert::Binance::TempMiniPairMapper
          .new(CryptoExpert::App.config.BINANCE_API_KEY)
          .get(MINI_SYMBOL)
        CryptoExpert::Repository::For.klass(CryptoExpert::Entity::TempMiniPair).db_find_or_create(minipair)
        # WHEN: user go to minipair page
        visit(MiniPairPage, using_params: {symbol: MINI_SYMBOL} ) do |page|
            # THEN: user should see basic info about the pair
            puts page.pair_volume
            _(page.pair_volume).must_equal minipair.volume.to_s
            _(page.pair_time_element.present?).must_equal true
        end
        
    end
  end
end
