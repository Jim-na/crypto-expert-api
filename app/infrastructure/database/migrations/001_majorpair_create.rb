# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:tempmajorpair) do
      primary_key :id

      String      :symbol, null: false
      Float       :spot_volume
      Float       :funding_rate
      Float       :longshort_ratio
      Float       :open_interest
      Float       :future_volume
      String      :time
    end
  end
end
