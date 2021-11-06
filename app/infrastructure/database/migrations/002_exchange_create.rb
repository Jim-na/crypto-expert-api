# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:exchanges) do
      primary_key :id

      String      :exchangename, unique: true, null: false
      
    end
  end
end