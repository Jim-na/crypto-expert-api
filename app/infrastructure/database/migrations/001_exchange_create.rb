# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:exchanges) do
      primary_key :id

      String      :exchangename, unique: true, null: false
      String      :timezone
    end
  end
end

=begin
ExchangeOrm.create(exchangename:'FTX')
CurrencyListOrm.create(symbol:'BTCUSDT', exchangeid:1)
ExchangeOrm.create(exchangename:'Binance')
CurrencyListOrm.create(exchangeid: 2, symbol: 'BTCUSDT')
CurrencyListOrm.create(exchangeid: 2, symbol:'ETHUSDT')
CurrencyListOrm.create(exchangeid: 1, symbol: 'BTCUSDT')
FundingRateListOrm.create(exchangeid:2, symbol:'BTCUSDT', price: 0.0987)
FundingRateListOrm.create(exchangeid:2, symbol:'ETHUSDT', price: 0.0777)
FundingRateListOrm.create(exchangeid:1, symbol:'ETHUSDT', price: 0.0977)
=end