# crypto-expert

soa project

We offer information and trading alert signal, which we combine and define the information from different resources, such as exchanges, social media popularity  and KOL's suggestion.

### Problem
- There are many different currencies and exchanges in cryptocurrency markets. Information is complicated and disorganized. 
- People could get them easily but can’t utilize it to make good decisions. 
- KOLs and information integration might help to solve this problem. 

Short-term usability goals

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