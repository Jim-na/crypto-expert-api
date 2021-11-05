# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:exchanges) do
      primary_key :id
      # foreign_key :futurepair, :futures

      # Integer     :origin_id, unique: true
      String      :exchangename, unique: true, null: false
      # String       :spotpair
      # String       :futurepair
      Array       :fundingrate_list
      
      # DateTime :created_at
      # DateTime :updated_at
      # index [exchangename,]
    end
  end
end
=begin
cd CryptoExpert/Database
btc = SpotOrm.create(symbol: 'BTCUSDT', price: '150000')
eth = SpotOrm.create(symbol: 'ETHUSDT', price: '5000')
bin = ExchangeOrm.create(exchangename:'Binance')
ftx = ExchangeOrm.create(exchangename:'FTX')
btc = SpotOrm.first
test.add_spotpair(btc)
test.spotpair
=end