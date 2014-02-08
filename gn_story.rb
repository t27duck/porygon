require "json"
require "net/http"
require "cgi"

class GnStory
  def invoke(data)
    message = data[:message].to_s.strip
    messages = message.split(" ")
    messages.each do |m|
      if (m.to_s =~ /http:\/\/(www.)?gonintendo.com\/\?(.+)/i) != nil
        return get_story_info(m)
      end
      if (m.to_s =~ /http:\/\/(www.)?gonintendo\.com\/s\/[a-z\-0-9]+/i) != nil
        return get_story_info2(m)
      end
    end
    nil
  end

  private #####################################################################

  def get_story_info(gn_url)
    params = CGI.parse(URI.parse(gn_url).query)
    if params["mode"] && !params["id"].empty? && params["mode"].first == "viewstory"
      story_id = params["id"].first.to_i
      return ping_site(story_id)
    end
    nil
  end

  def get_story_info2(gn_url)
    # http://gonintendo.com/s/1234-abcd
    story_id = gn_url.split("/s/").last.to_i
    ping_site(story_id)
  end

  def ping_site(story_id)
    url = URI.parse("http://www.gonintendo.com/feeds/porygon_story_json.php?id=#{story_id}")
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    return nil unless res.code == "200"
    body = JSON.parse(res.body)
    rating = body['thumbs_up'].to_i - body['thumbs_down'].to_i
    "#{body['title']} (Posted on #{body['published']}) Rating: #{rating} [+#{body['thumbs_up'].to_i} -#{body['thumbs_down'].to_i}]"
  rescue
    nil
  end
  
end
