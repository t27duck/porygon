module Apixu
  module Errors
    class InvalidKey < StandardError; end
    class Request < StandardError
      def initialize code, message
        super "#{code}: #{message}"
      end
    end
  end

  class Client
    attr_reader :key

    BASE_URL = "http://api.apixu.com/v1"

    def initialize key=nil
      @key = key || ENV["APIXU_KEY"]

      unless @key
        raise Errors::InvalidKey
      end
    end

    def url endpoint
      "#{BASE_URL}/#{endpoint}.json"
    end

    def request key, params={}
      params["key"] = @key
      result = JSON::parse(RestClient.get url(key), params: params)

      if result["error"]
        raise Errors::Request.new(result["error"]["code"], result["error"]["message"])
      else
        result
      end
    end

    def current query
      request :current, q: query
    end

    def forecast query, days=1
      request :forecast, q: query, days: days
    end
  end
end

class Weather
  include Cinch::Plugin

  match(/weather ([\w, ]+)/i, strip_colors: true)

  def execute(m, search_term)
    return unless CONFIG["weather"]

    term = search_term.downcase
    m.reply make_request(term)
  rescue => e
    puts e.message
    error = "Unable to get weather"
    search_options = "city name (with optional region and country), US zip code, Canada postal code, UK postcode, etc"
    fallback = "You can try searching at https://www.apixu.com/weather/"
    m.reply "#{error}. You can search by #{search_options}. #{fallback}."
  end

  private ######################################################################

  def make_request(term)
    parse_response api_wrapper.current(term)
  end

  def parse_response(body)
    location = "#{body["location"]["name"]}"
    country = body["location"]["country"]
    if ["United States of America", "USA", "US"].include?(country)
      location << ", #{body["location"]["region"]}"
    else
      location << ", #{country}"
    end

    condition = body["current"]["condition"]["text"]
    temp = "#{body["current"]["temp_f"]}F (#{body["current"]["temp_c"]}C)"
    humidity = body["current"]["humidity"]
    wind = "#{body["current"]["wind_dir"]} at #{body["current"]["wind_mph"]}MPH"

    body = "Currently in #{location}: "
    body << "#{condition}, #{temp}, "
    body << "Humidity: #{humidity}%, "
    body << "Wind: #{wind}. "
    body << "Powered by APIXU."

    body
  end

  def api_wrapper
    @api_wrapper ||= Apixu::Client.new(CONFIG["weather"]["api_key"])
  end
end
