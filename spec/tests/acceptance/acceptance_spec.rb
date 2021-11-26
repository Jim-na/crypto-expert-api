require_relative '../../spec_helper'
require_relative '../../helpers/database_helper'
require_relative '../../helpers/vcr_helper'

# require 'headless'
require 'webdrivers/chromedriver'
require 'watir'

describe 'Acceptance Tests' do
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
    describe 'Visit Home page' do
      it '(HAPPY) should not get error when click nav bar' do
        # GIVEN: user is on the home page without any projects
        @browser.goto homepage

        # THEN: user should see basic headers, no projects and a welcome message
        _(@browser.a(id: 'brand').present?).must_equal true
        _(@browser.a(class: 'navbar-brand').text).must_equal 'Crypto Alert'

        # THEN: they should find themselves on the project's page
        _(@browser.button(id: 'minipair-submit').present?).must_equal true
      end
    end
    describe 'Add MiniPair' do
      it '(HAPPY) should be able to request a minipair' do
        # GIVEN: user is on the home page
        @browser.goto homepage

        # WHEN: they add a minipair symbol and submit
        @browser.text_field(id: 'symbol_input').set(MINI_SYMBOL)
        @browser.button(id: 'minipair-submit').click

        # THEN: they should find the symbol they entered
        @browser.url.include? MINI_SYMBOL
      end

      it '(BAD) should not be able to add an non-existent pair' do
        # GIVEN: user is on the home page
        @browser.goto homepage

        # WHEN: they request a pair with an non-existent symbol
        bad_symbol = 'foobar'
        @browser.text_field(id: 'symbol_input').set(bad_symbol)
        @browser.button(id: 'minipair-submit').click

        # THEN: they should see a warning message
        _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
        _(@browser.div(id: 'flash_bar_danger').text.downcase).must_include 'not find'
      end
    end
  end

  describe 'Mini Pair' do
    describe 'Visit Mini pair list page' do
      it '(HAPPY) should get hint when click nav bar minipair' do
        # GIVEN: user is on the home page
        @browser.goto homepage

        # WHEN: user has not added pair
        @browser.goto 'http://localhost:9292/minipair'

        # THEN: they should see a warning message
        _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
        _(@browser.div(id: 'flash_bar_danger').text.downcase).must_include 'start'
      end
      it '(HAPPY) should not get the request minipair table' do
        # GIVEN: a symbol that in the database but user has not request it
        minipair = CryptoExpert::Binance::TempMiniPairMapper
          .new(CryptoExpert::App.config.BINANCE_API_KEY)
          .get(MINI_SYMBOL)
        CryptoExpert::Repository::For.klass(CryptoExpert::Entity::TempMiniPair).db_find_or_create(minipair)

        # WHEN: user go back to minipair list
        @browser.goto 'http://localhost:9292/minipair'

        # THEN: they should not see the pair they didn't enter
        _(@browser.table(id: 'pair-table').exist?).must_equal false
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
        @browser.goto "http://localhost:9292/minipair/#{MINI_SYMBOL}"

        # THEN: user should see basic info about the pair
        _(@browser.span(class: 'pair volume').text).must_equal minipair.volume.to_s
        _(@browser.span(class: 'pair time').present?).must_equal true
      end
    end
  end
end
#
#
#     describe 'Project Page' do
#       it '(HAPPY) should see project content if project exists' do
#         # GIVEN: a project exists
#         project = CodePraise::Github::ProjectMapper
#           .new(GITHUB_TOKEN)
#           .find(USERNAME, PROJECT_NAME)
#
#         CodePraise::Repository::For.entity(project).create(project)
#
#         # WHEN: user goes directly to the project page
#         @browser.goto "http://localhost:9000/project/#{USERNAME}/#{PROJECT_NAME}"
#
#         # THEN: they should see the project details
#         _(@browser.h2.text).must_include USERNAME
#         _(@browser.h2.text).must_include PROJECT_NAME
#
#         contributor_columns = @browser.table(id: 'contribution_table').thead.ths.select do |col|
#           col.attribute(:class).split.sort == %w[contributor username]
#         end
#
#         _(contributor_columns.count).must_equal 3
#
#         _(contributor_columns.map(&:text).sort)
#           .must_equal ['SOA-KunLin', 'Yuan-Yu', 'luyimin']
#
#         folder_rows = @browser.table(id: 'contribution_table').trs.select do |row|
#           row.td(class: %w[folder name]).present?
#         end
#
#         _(folder_rows.count).must_equal 10
#
#         file_rows = @browser.table(id: 'contribution_table').trs.select do |row|
#           row.td(class: %w[file name]).present?
#         end
#
#         _(file_rows.count).must_equal 2
#       end
#
#       it '(HAPPY) should be able to traverse to subfolders' do
#         project = CodePraise::Github::ProjectMapper
#           .new(GITHUB_TOKEN)
#           .find(USERNAME, PROJECT_NAME)
#
#         CodePraise::Repository::For.entity(project).create(project)
#
#         @browser.goto "http://localhost:9000/project/#{USERNAME}/#{PROJECT_NAME}"
#
#         folder_rows = @browser.table(id: 'contribution_table').trs.select do |row|
#           row.td(class: %w[folder name]).present?
#         end
#
#         views_folder = folder_rows.last.tds.find do |column|
#           column.link.href.include? 'views_objects'
#         end
#
#         views_folder.link.click
#
#         _(@browser.h2.text).must_include USERNAME
#         _(@browser.h2.text).must_include PROJECT_NAME
#
#         folder_rows = @browser.table(id: 'contribution_table').trs.select do |row|
#           row.td(class: %w[folder name]).present?
#         end
#
#         file_rows = @browser.table(id: 'contribution_table').trs.select do |row|
#           row.td(class: %w[file name]).present?
#         end
#
#         _(folder_rows).must_be_empty
#         _(file_rows.count).must_equal 5
#       end
#
#       it '(BAD) should report error if subfolder does not exist' do
#         # GIVEN a project that exists
#         project = CodePraise::Github::ProjectMapper
#           .new(GITHUB_TOKEN)
#           .find(USERNAME, PROJECT_NAME)
#
#         CodePraise::Repository::For.entity(project).create(project)
#
#         # WHEN user goes to a non-existent folder of the project
#         @browser.goto "http://localhost:9000/project/#{USERNAME}/#{PROJECT_NAME}/bad_folder"
#
#         # THEN: user should see a warning message
#         _(@browser.div(id: 'flash_bar_danger').present?).must_equal true
#         _(@browser.div(id: 'flash_bar_danger').text.downcase).must_include 'could not find'
#       end
#     end
#   end
#
