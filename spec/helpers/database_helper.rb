# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
    def self.wipe_database
      # Ignore foreign key constraints when wiping tables
      CryptoExpert::App.DB.run('PRAGMA foreign_keys = OFF')
      CryptoExpert::Database::ExchangeOrm.map(&:destroy)
      CryptoExpert::Database::SpotOrm.map(&:destroy)
      CryptoExpert::Database::FutureOrm.map(&:destroy)
      CryptoExpert::App.DB.run('PRAGMA foreign_keys = ON')
    end
end
  