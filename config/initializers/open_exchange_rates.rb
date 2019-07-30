require 'money/bank/open_exchange_rates_bank'

# Memory store per default; for others just pass as argument a class like
# explained in https://github.com/RubyMoney/money#exchange-rate-stores
oxr = Money::Bank::OpenExchangeRatesBank.new
oxr.app_id = ENV['OXR_APP_ID']
oxr.update_rates

# (optional)
# See https://github.com/spk/money-open-exchange-rates#cache for more info
# Updated only when `refresh_rates` is called
#oxr.cache = "tmp/#{Rails.env}_cache.json"

if Rails.env.test?
  oxr.cache = Rails.root.join("spec/fixtures/currency-rates.json").to_s
else
  OXR_CACHE_KEY = "#{Rails.env}:money:exchange_rates".freeze

  oxr.cache = Proc.new do |text|
    if text
      Rails.cache.write(OXR_CACHE_KEY, text)
    else
      Rails.cache.read(OXR_CACHE_KEY)
    end
  end
end

# (optional)
# Set the seconds after than the current rates are automatically expired
# by default, they never expire, in this example 1 day.
# This ttl is about money store (memory, database ...) passed though
# `Money::Bank::OpenExchangeRatesBank` as argument not about `cache` option.
# The base time is the timestamp fetched from API.
#oxr.ttl_in_seconds = 86400

# (optional)
# Set historical date of the rate
# see https://openexchangerates.org/documentation#historical-data
#oxr.date = '2015-01-01'

# (optional)
# Set the base currency for all rates. By default, USD is used.
# OpenExchangeRates only allows USD as base currency
# for the free plan users.
oxr.source = 'USD'

# (optional)
# Extend returned values with alternative, black market and digital currency
# rates. By default, false is used
# see: https://docs.openexchangerates.org/docs/alternative-currencies
#oxr.show_alternative = true

# (optional)
# Minified Response ('prettyprint')
# see https://docs.openexchangerates.org/docs/prettyprint
oxr.prettyprint = false

# (optional)
# Refresh rates, store in cache and update rates
# Should be used on crontab/worker/scheduler `Money.default_bank.refresh_rates`
# If you are using unicorn-worker-killer gem or on Heroku like platform,
# you should avoid to put this on the initializer of your Rails application,
# because will increase your OXR API usage.
#oxr.refresh_rates

# (optional)
# Force refresh rates cache and store on the fly when ttl is expired
# This will slow down request on get_rate, so use at your on risk, if you don't
# want to setup crontab/worker/scheduler for your application.
# Again this is not safe with multiple servers and could increase API usage.
#oxr.force_refresh_rate_on_expire = true

Money.default_bank = oxr

Money.default_bank.get_rate('USD', 'COP')
