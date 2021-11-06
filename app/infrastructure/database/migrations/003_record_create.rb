# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:records) do
      primary_key :id
      foreign_key :exchange_id, :exchanges
      foreign_key :spot_id, :spots

      Float :addqty
      Float :minusqty
      Float :price
      Bool :buy
      DateTime :time

    end
  end
end
