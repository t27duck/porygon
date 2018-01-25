require "cgi"
require "net/http"
require "json"

class Currency
  include Cinch::Plugin

  UnknownCurrency = Class.new(StandardError)

  BASE_CURRENCY = "USD".freeze

  def initialize(*args)
    super
    @rates ||= { pulled: nil, rates: {}}
  end

  match(/currency ([\d\.]+) ([A-Z]+) to ([A-Z]+)\z/i, use_prefix: true, strip_colors: true)

  def execute(m, value, source_currency, target_currency)
    source_currency.upcase!
    target_currency.upcase!

    rate = calculate_exchange_rate(source_currency, target_currency)
    result = value.to_d * rate
    m.reply "#{source_currency} -> #{target_currency}: #{result.round(2)} (approx.)"
  rescue UnknownCurrency => e
    m.reply "Invalid currency '#{e.message}' ... Valid currencies are: #{@rates[:rates].keys.sort.join(", ")}"
  rescue => e
    m.reply "Error: #{e.message.split("\n")[0]}"
  end

  private ######################################################################

  def get_rates
    return @rates[:rates] if !@rates[:rates].empty? && Time.now.to_i - @rates[:pulled].to_i <= 60 * 60 * 8

    url = URI.parse("https://api.fixer.io/latest?base=#{BASE_CURRENCY}")
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = true
    res = req.get(url.request_uri)

    @rates[:pulled] = Time.now
    @rates[:rates] = JSON.parse(res.body)["rates"]
    @rates[:rates][BASE_CURRENCY] = 1

    @rates[:rates]
  end

  def calculate_exchange_rate(source_currency, target_currency)
    rates = get_rates
    raise UnknownCurrency, target_currency if rates[target_currency].nil?
    raise UnknownCurrency, source_currency if rates[source_currency].nil?

    return rates[target_currency].to_d if source_currency == BASE_CURRENCY
    return rate = 1.to_d if source_currency == target_currency
    (1.to_d / rates[source_currency].to_d) * rates[target_currency].to_d
  end
end
