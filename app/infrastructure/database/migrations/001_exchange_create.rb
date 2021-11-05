# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:exchanges) do
      primary_key :id

      # Integer     :origin_id, unique: true
      String      :exchangename, unique: true, null: false
      Array       :spotpair_list
      Array       :futurepair_list
      Array       :fundingrate_list
    #   String      :

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
