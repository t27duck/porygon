class Weather
  include Cinch::Plugin

  def initialize(*args)
    super
    @cached_responses ||= {}
  end

  match(/weather ([\w, ]+)/i, strip_colors: true)

  def execute(m, search_term)
    return unless CONFIG["weather"]

    @term = search_term.downcase
    response = lookup_cache
    response = store_cache(make_request) if response.nil?

    m.reply response
  rescue => e
    puts e.message
  end

  private ######################################################################

  def make_request
    terms = @term.split(',').map(&:strip).reverse
    api_wrapper.conditions_for(*terms)
  end

  def lookup_cache
    cached_response = @cached_responses[@term]
    # last_request is in seconds
    if cached_response && Time.now - cached_response[:last_request] > 900
      return cached_response[:body]
    end
    nil
  end

  def store_cache(body)
    if body['response']['error'] && body['response']['error']['description']
      body = body['response']['error']['description']
    else
      ob = body['current_observation']
      body = "Currently in #{ob['display_location']['full']}: "
      body << " #{ob['weather']}, #{ob['temperature_string']}, "
      body << "Humidity: #{ob['relative_humidity']}, "
      body << "Wind: #{ob['wind_string']}. "
      body << "Powered by Weather Underground."
    end
    @cached_responses[@term] = {
      body: body,
      last_request: Time.now
    }
    @cached_responses[@term][:body]
  end

  def api_wrapper
    @api_wrapper ||= Wunderground.new(CONFIG["weather"]["api_key"])
  end
end
