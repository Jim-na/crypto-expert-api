# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:spots) do
      primary_key :id

      String      :symbol, unique: true, null: false
      Float       :price

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
