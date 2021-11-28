# frozen_string_literal: true

require 'figaro'
require 'roda'
require 'sequel'
require 'yaml'
require 'delegate' # needed until Rack 2.3 fixes delegateclass bug

module CryptoExpert
  # Configuration for the App
  class App < Roda
    plugin :environments

    # rubocop:disable Lint/ConstantDefinitionInBlock
    configure do
      # Environment variables setup
      Figaro.application = Figaro::Application.new(
        environment: environment,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load
      def self.config() = Figaro.env

      use Rack::Session::Cookie, secret: config.SESSION_SECRET

      configure :development, :test, :app_test do
        require 'pry'; # for breakpoints
        ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
      end

      configure :app_test do
        require_relative '../spec/helpers/vcr_helper'
        VcrHelper.setup_vcr
        VcrHelper.configure_vcr_for_bn(recording: :new_episodes)
      end

      # Database Setup
      DB = Sequel.connect(ENV['DATABASE_URL'])
      def self.DB() = DB # rubocop:disable Naming/MethodName
    end
  end
end
