# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'

describe 'Homepage Acceptance Tests' do
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
  describe 'Visit Home Page' do
    it '(HAPPY) should get correct nav bar' do
      # GIVEN: no pair search
      # THEN: user is on the home page
      visit HomePage do |page|
        # THEN: user should see homepage well
        _(page.navbar_brand).must_equal 'Crypto Alert'
        _(page.navbar_element.present?).must_equal true
        _(page.symbol_input_element.present?).must_equal true
        _(page.search_button_element.present?).must_equal true
      end
    end
  end
  describe 'Add MiniPair' do
    it '(HAPPY) should be able to request a minipair' do
      # GIVEN: user is on the home page
      visit HomePage do |page|
        # WHEN: they add a minipair symbol and submit
        page.add_new_pair(MINI_SYMBOL)
      end
      # THEN: they should find the symbol they entered
      @browser.url.include? MINI_SYMBOL
    end

    it '(BAD) should not be able to add an non-existent pair' do
      # GIVEN: user is on the home page
      visit HomePage do |page|
        # WHEN: they add a minipair symbol and submit
        bad_symbol = 'foobar'
        page.add_new_pair(bad_symbol)
        # THEN: they should find the symbol they entered
        _(page.warning_message.downcase).must_include 'not find'
      end
    end
  end
end
