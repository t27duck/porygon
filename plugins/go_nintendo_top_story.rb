require "json"
require "net/http"
require "cgi"

class GoNintendoTopStory
  include Cinch::Plugin

  def initialize(*args)
    super
    @last_top_story_url ||= nil
  end

  def check_site
    url = URI.parse("http://www.gonintendo.com/content/json/chrome-1.json")
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    return unless res.code == "200"
    body = JSON.parse(res.body)
    messages = []

    first_top_story_url = body['top_stories'].first['url']
    if @last_top_story_url.nil?
      @last_top_story_url = first_top_story_url
      return
    end
    if @last_top_story_url != first_top_story_url
      old_top_story_url = @last_top_story_url
      @last_top_story_url = first_top_story_url
      body['top_stories'].each do |ts|
        if ts['url'] != old_top_story_url
          messages << "New Top Story: #{ts['title']} - #{ts['url']}"
        else
          break
        end
      end
    end
    messages.each do |message|
      Channel("#gonintendo").send message
    end
  rescue
  end

  timer (10 * 60), :method => :check_site
end

