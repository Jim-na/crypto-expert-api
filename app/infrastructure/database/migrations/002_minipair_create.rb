# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:minipair) do
      primary_key :id

      String      :symbol , null: false
      Float       :volume
      DateTime    :time
    end
  end
end
