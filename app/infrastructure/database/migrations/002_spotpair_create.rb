# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:spots) do
      primary_key :id
      foreign_key :exchangeid, :exchanges, null: false

      String      :symbol, null: false
      Float       :price, null: false
      DateTime    :timestamp
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
