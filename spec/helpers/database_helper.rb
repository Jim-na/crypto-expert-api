# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    CryptoExpert::App.DB.run('PRAGMA foreign_keys = OFF')
    CryptoExpert::Database::TempMiniPairOrm.map(&:destroy)
    CryptoExpert::App.DB.run('PRAGMA foreign_keys = ON')
  end
end
