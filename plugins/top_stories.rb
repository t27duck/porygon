require "json"
require "net/http"
require "cgi"

class TopStories
  include Cinch::Plugin

  def initialize(*args)
    super
    @last_top_story_url ||= {}
  end

  def check_sites
    [
      {:url => "http://www.gonintendo.com/content/json/chrome-1.json", :channel => "#gonintendo"},
      {:url => "http://goingsony.com/porygon/top_stories.json?key=#{CONFIG["porygon_key"]}", :channel => "#goingsony"}
    ].each do |site|
      check_site(site)
    end
  end

  timer (10 * 60), :method => :check_sites

  private ######################################################################

  def check_site(site)
    body = fetch_json(site[:url])
    return if body.nil?

    messages = build_messages(site[:channel], body)
    return if messages.empty?

    send_messages(site[:channel], messages)
  end

  def build_messages(channel, body)
    messages = []

    first_top_story_url = body['top_stories'].first['url']
    if @last_top_story_url[channel].nil?
      @last_top_story_url[channel] = first_top_story_url
      return []
    end

    if @last_top_story_url[channel] != first_top_story_url
      old_top_story_url = @last_top_story_url[channel]
      @last_top_story_url[channel] = first_top_story_url
      body['top_stories'].each do |ts|
        if ts['url'] != old_top_story_url
          messages << "New Top Story: #{ts['title']} - #{ts['url']}"
        else
          break
        end
      end
    end
    messages
  end

  def send_messages(channel, messages)
    messages.each do |message|
      Channel("#gonintendo").send message
    end
  end

  def fetch_json(url)
    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    return nil unless res.code == "200"
    JSON.parse(res.body)
  rescue
    nil
  end
end
