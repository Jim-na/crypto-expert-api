# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:signal) do
      primary_key :id

      String      :symbol, null: false
      Float       :volume_change_percent
      String      :signal
      Integer     :signal_score
      String      :time
      Float       :spot_volume
      Float       :spot_closeprice
      Float       :funding_rate
      Float       :longshort_ratio
      Float       :open_interest
      Float       :spot_change_percent
      Float       :funding_rate_history
      Float       :longshort_ratio_history
      Float       :open_interest_history
    end
  end
end
