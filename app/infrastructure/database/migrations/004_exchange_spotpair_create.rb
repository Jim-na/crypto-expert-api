# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:exchange_spotpair) do
      primary_key [:exchange_id, :spot_id]
      foreign_key :exchange_id, :exchanges
      foreign_key :spot_id, :spots

      index [:exchange_id, :spot_id]
    end
  end
end
