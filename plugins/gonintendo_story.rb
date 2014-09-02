require "json"
require "net/http"

class GoNintendoStory
  include Cinch::Plugin

  match /http:\/\/w{0,3}\.?gonintendo\.com\/s\/([a-z\-0-9]+)/i, :use_prefix => false, :strip_colors => true
  match /http:\/\/w{0,3}\.?gonintendo\.com\/\?mode=viewstory&id=([0-9]+)/i, :use_prefix => false, :strip_colors => true

  def execute(m, story_id)
    story_id = story_id.to_i
    url = URI.parse("http://www.gonintendo.com/feeds/porygon_story_json.php?id=#{story_id}")
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    return nil unless res.code == "200"
    body = JSON.parse(res.body)
    rating = body['thumbs_up'].to_i - body['thumbs_down'].to_i
    m.reply "#{body['title']} (Posted on #{body['published']}) Rating: #{rating} [+#{body['thumbs_up'].to_i} -#{body['thumbs_down'].to_i}]"
  rescue
  end
end
