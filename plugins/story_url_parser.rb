require "json"
require "net/http"

class StoryUrlParser
  include Cinch::Plugin

  match /http:\/\/w{0,3}\.?gonintendo\.com\/s\/([a-z\-0-9]+)/i, :use_prefix => false, :strip_colors => true, :method => "gonintendo"
  match /http:\/\/w{0,3}\.?gonintendo\.com\/\?mode=viewstory&id=([0-9]+)/i, :use_prefix => false, :strip_colors => true, :method => "gonintendo"

  def gonintendo(m, story_id)
    story_id = story_id.to_i
    body = make_request("http://www.gonintendo.com/feeds/porygon_story_json.php?id=#{story_id}")
    return if body.nil?
    rating = body['thumbs_up'].to_i - body['thumbs_down'].to_i
    m.reply "#{body["title"]} (Posted on #{body["published"]}) Rating: #{rating} [+#{body["thumbs_up"].to_i} -#{body["thumbs_down"].to_i}]"
  end

  def goingsony(m, story_id)
    story_id = story_id.to_i
    body = make_request("http://goingsony.com/porygon/story.json?id=#{story_id}&key=#{CONFIG["porygon_key"]}")
    return if body.nil?
    m.reply "#{body["title"]} (Posted on #{body["published"]}) Rating: #{body["rating"]} [+#{body["positive"].to_i} -#{body["negative"].to_i}]"
  end

  private ######################################################################

  def make_request(url)
    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    return nil unless res.code == "200"
    JSON.parse(res.body)
  rescue
    nil
  end
end
