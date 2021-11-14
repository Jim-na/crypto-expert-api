# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
    CASSETTES_FOLDER = './spec/fixtures/cassettes'.freeze
    CASSETTES_FILE = 'binance_api'.freeze

  def self.setup_vcr
    VCR.configure do |c|
        c.cassette_library_dir = CASSETTES_FOLDER
        c.hook_into :webmock
    end
  end

  def self.configure_vcr_for_bn

    VCR.insert_cassette CASSETTES_FILE,
                    record: :new_episodes,
                    match_requests_on: %i[method uri headers]
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end