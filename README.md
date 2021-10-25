# crypto-expert

soa project

We offer information from the markets, such as exchanges price, funding rate , KOL's suggestion, whale alert ... and more.

Short-term usability goals

- to show all the information that we thought the investor in cryptocurrency market will need.
  Long-term goals
- Combine all useful info to give a investment suggestion.
- Build a tg bot(or other bot) to make an order directly and offer some customized notification alert.

API Library

- Info API : an api to get information from different exchanges. <= this is the main class to get info.
- Binance API : define the api to binance to get info.
- Currency pair : define the pair ,for example, ETHUSDT, to store information (price or tick , volume) of each pair.
- Http API : define the http request to the client.
