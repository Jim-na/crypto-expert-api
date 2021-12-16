# crypto-expert

soa project

We offer information and trading alert signal, which we combine and define the information from different resources, such as exchanges, social media popularity and KOL's suggestion.

## Note:

Binance Api **will fail in NTHU ip**. We used vpn to get binance.com.

## API

test

- Temp minipair
  - `curl -X POST http://127.0.0.1:9000/api/v1/tempminipair/BTCUSDT`
  - `{"symbol":"BTCUSDT","time":1638630000000,"spot_volume":3265.95713,"future_volume":16603.96,"funding_rate":6.285e-05,"longshort_ratio":2.6377,"open_interest":41706.433,"spot_closeprice":47828.29,"links":[{"rel":"self","href":"/api/v1/tempminipair/BTCUSDT"}]}`
- Minipair (DOMAIN SIGNAL)
  - `curl -X POST http://127.0.0.1:9000/api/v1/minipair/BTCUSDT`
  - `{"symbol":"BTCUSDT","volume_change_percent":-43.83043294876317,"signal":"BEAR","time":1638691200000,"spot_volume":1834.47398,"spot_closeprice":49289.18,"funding_rate":9.001e-05,"longshort_ratio":2.4758,"open_interest":40435.567,"spot_change_percent":3.0544474828600383,"links":[{"rel":"self","href":"/api/v1/minipair/BTCUSDT"}]}`
- Minipair List (signal list)
  - `curl http://127.0.0.1:9000/api/v1/minipair?list=WyJCVENVU0RUIiwiRVRIVVNEVCJd`
  - `WyJCVENVU0RUIiwiRVRIVVNEVCJd` = base64 encode ["BTCUSDT","ETHUSDT"]
  - `{"minipairs":[{"symbol":"BTCUSDT","volume_change_percent":-43.83043294876317,"signal":"BEAR","time":1638691200000,"spot_volume":1834.47398,"spot_closeprice":49289.18,"funding_rate":9.001e-05,"longshort_ratio":2.4758,"open_interest":40435.567,"spot_change_percent":3.0544474828600383,"links":[{"rel":"self","href":"/api/v1/minipair/BTCUSDT"}]},{"symbol":"ETHUSDT","volume_change_percent":0.0,"signal":"HOLD","time":1638691200000,"spot_volume":24872.7,"spot_closeprice":4199.52,"funding_rate":0.0001,"longshort_ratio":2.252,"open_interest":302590.39,"spot_change_percent":0.0,"links":[{"rel":"self","href":"/api/v1/minipair/ETHUSDT"}]}]}`

### Problem

- There are many different currencies and exchanges in cryptocurrency markets. Information is complicated and disorganized.
- People could get them easily but can’t utilize it to make good decisions.
- KOLs and information integration might help to solve this problem.

### Short-term usability goals

- to show all the information that we thought the investor in cryptocurrency market will need.

### Long-term goals

- Combine all useful info to give a investment suggestion or signal.
- Build a telegram bot(or other bot) to offer some customized notification alert.
- The alert is the signal = domain logic , ex:

  - Open interest raising rapidly with high volume and price increasing.
  - Specified coin is blowing up social media now with more than 2 KOL’s has mentioned about it.

- RUN `ruby ./init.rb` to init all relative file
- I can't use `rackup` , so **I use `bundle exec rackup` to run the app.**

### API Library

- ~~Info API : an api to get information from different exchanges. <= this is the main class to get info.~~
- Binance::API : define the api to binance to get info.
- Currency pair : define the pair ,for example, ETHUSDT, to store information of each pair.
  - Spot: price
  - Future: price, funding rate
- Exchange Info : to get time zone, current list and funding rate list of exchanges
- Http API : define the http request to the client.

Database

ER-diagram

![](https://i.imgur.com/4vW3rvC.png)
