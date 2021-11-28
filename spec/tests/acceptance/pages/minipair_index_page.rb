# frozen_string_literal: true

# Page object for home page
class MiniPairIndexPage
  include PageObject

  page_url CryptoExpert::App.config.APP_HOST + '/minipair'

  div(:warning_message, id: 'flash_bar_danger')
  div(:success_message, id: 'flash_bar_success')
  # NAV BAR
  element(:navbar, id: 'nav')
  element(:navbar_brand, id: 'brand')
  text_field(:symbol_input, id: 'symbol_input')
  button(:search_button, id: 'minipair-submit')

  # minipair index page
  table(:pairtable, id: 'pairtable')

  def add_new_pair(symbol)
    self.symbol_input = symbol
    search_button
  end
end
