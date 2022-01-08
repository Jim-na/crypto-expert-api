# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
module VcrHelper
  CASSETTES_FOLDER = './spec/fixtures/cassettes'
  CASSETTES_FILE = 'binance_api'

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
      vcr_config.ignore_hosts 'sqs.us-east-1.amazonaws.com'
    end
  end

  def self.configure_vcr_for_bn(recording: :new_episodes)
    VCR.insert_cassette CASSETTES_FILE,
                        record: recording,
                        match_requests_on: %i[method uri headers],
                        allow_playback_repeats: true
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
