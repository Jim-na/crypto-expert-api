# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:fundingratelist) do
      primary_key :id
      foreign_key :exchangeid, :exchanges, null: false

      String      :symbol
      String      :price
      unique      %i[exchangeid symbol]

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
