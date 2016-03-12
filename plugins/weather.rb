require "json"
require "cgi"
require "net/http"

class Weather
  include Cinch::Plugin

  def initialize(*args)
    super
    @cached_responses ||= {}
  end

  match /weather (\w+)/i, strip_colors: true

  def execute(m, search_term)
    return unless CONFIG["weather"]

    @term = search_term.downcase
    response = lookup_cache
    response = store_cache(make_request) if response.nil?

    m.reply response
  rescue
  end

  private ######################################################################

  def make_request
    search_key = @term.size == 5 ? 'zip' : 'q'
    url = URI.parse("http://api.openweathermap.org/data/2.5/weather?units=imperial&APPID=#{CONFIG["weather"]["api_key"]}&#{search_key}=#{CGI.escape(@term)}")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    return unless res.code == '200'
    JSON.parse(res.body)
  end

  def lookup_cache
    cached_response = @cached_responses[@term]
    if cached_response
      return cached_response[:body] if Time.now - cached_response[:last_request] > 900 # 15 minutes
    end
    nil
  end

  def store_cache(body)
    @cached_responses[@term] = {
      body: "Currently in #{body['name']} - #{body['weather'].first['description']}, #{body['main']['temp']}F, Humidity #{body['main']['humidity']}%. Powered by openweathermap.org",
      last_request: Time.now
    }
    @cached_responses[@term][:body]
  end
end
