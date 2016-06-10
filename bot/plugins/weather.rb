class Weather
  include Cinch::Plugin

  match(/weather ([\w, ]+)/i, strip_colors: true)

  def execute(m, search_term)
    return unless CONFIG["weather"]

    term = search_term.downcase
    m.reply make_request(term)
  rescue => e
    puts e.message
  end

  private ######################################################################

  def make_request(term)
    terms = term.split(',').map(&:strip).reverse
    parse_response api_wrapper.conditions_for(*terms)
  end

  def parse_response(body)
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
    body
  end

  def api_wrapper
    @api_wrapper ||= Wunderground.new(CONFIG["weather"]["api_key"])
  end
end
