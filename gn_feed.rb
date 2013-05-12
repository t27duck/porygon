require "json"
require "net/http"
require "cgi"

class GnFeed
  def initalize
    @last_top_story_url = nil
    @feed_player_status = nil
  end

  def check
    url = URI.parse("http://www.gonintendo.com/content/json/chrome-1.json")
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    return [] unless res.code == "200"
    body = JSON.parse(res.body)
    messages = []
    
    player_status = body['live_stream']['active'].to_s
    if @feed_player_status != player_status
      @feed_player_status = player_status
      if @feed_player_status == "1"
        messages << "NOTICE: GoNintendo live stream player is active on the site!"
      end
    end

    first_top_story_url = body['top_stories'].first['url']
    if @last_top_story_url.nil?
      @last_top_story_url = first_top_story_url
      return []
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
    return messages
  rescue
    return []
  end
end
