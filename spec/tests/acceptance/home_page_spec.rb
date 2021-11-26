# frozen_string_literal: true

require_relative '../../helpers/acceptance_helper'
require_relative 'pages/home_page'

describe 'Acceptance Tests' do
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
  describe 'Homepage' do
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

    # it '(BAD) should not be able to add an non-existent pair' do
    #   # GIVEN: user is on the home page
    #   @browser.goto homepage

    #   # WHEN: they request a pair with an non-existent symbol
    #   bad_symbol = 'foobar'
    #   @browser.text_field(id: 'symbol_input').set(bad_symbol)
    #   @browser.button(id: 'minipair-submit').click

    #   # THEN: they should see a warning message
    #   _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
    #   _(@browser.div(id: 'flash_bar_danger').text.downcase).must_include 'not find'
    # end
  end
  
end
