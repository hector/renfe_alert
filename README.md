# RENFE ALERT

Renfe is an Spanish company that operates most of the trains.
This is a script that scraps Renfe's webpage to notify you when new trains are available to buy, so you can get the best deal :)

## REQUIREMENTS

1. Install [PhantomJS](http://phantomjs.org/)
2. Install Ruby (99% chances you already have it)
3. Install bundler: `gem install bundler`
4. Install ruby dependencies: `bundle install`

To receive notifications on your mobile phone you need to:

1. Have an account on [IFTTT](https://ifttt.com)
2. Activate the [Maker channel](https://ifttt.com/maker) in IFTTT
3. Copy your Maker Channel key in a file in this project's folder called "key"
4. Add [this](https://ifttt.com/recipes/351565-send-notifications-to-your-mobile-phone) IFTTT recipe (use "notification" as the name of the event of the web request)
5. Install [IF App](https://ifttt.com/products) on the devices you want to recieve notifications [Android]
6. Login to the IF App with your IFTTT account

## USAGE

Just run renfe_alert.rb script from a shell
```
$> ./renfe_alert.rb 
```

Ideally you want to have it running periodically in a 24/7 machine (like a server or a Raspberry Pi). Running `whenever -w` will create a cron task to execute the script every hour (to modify this behaviour see [whenever gem](https://github.com/javan/whenever)).
