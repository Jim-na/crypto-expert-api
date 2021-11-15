# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:tempminipair) do
      primary_key :id

      String      :symbol, null: false
      Float       :volume
      String      :time
    end
  end
end
