# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:majorpair) do
      primary_key :id

      String      :symbol, null:false
      Float       :volume
      Float       :funding_rate
      Float       :longshort_ratio
      Float       :open_interest
      Float       :future_valume
      DateTime    :time

    end
  end
end
