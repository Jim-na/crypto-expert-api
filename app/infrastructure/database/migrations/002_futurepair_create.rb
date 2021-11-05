# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:futures) do
      primary_key :id
      # foreign_key :exchange_id, :exchanges

      # Integer     :origin_id, unique: true
      String      :symbol, unique: true, null: false
      String      :price
      String      :funding_rate

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
