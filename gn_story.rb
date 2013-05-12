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
    end
    nil
  end

  private #####################################################################

  def get_story_info(gn_url)
    params = CGI.parse(URI.parse(gn_url).query)
    if params["mode"] && !params["id"].empty? && params["mode"].first == "viewstory"
      story_id = params["id"].first.to_i
      url = URI.parse("http://www.gonintendo.com/feeds/porygon_story_json.php?id=#{story_id}")
      req = Net::HTTP::Get.new(url.request_uri)
      res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
      return nil unless res.code == "200"
      body = JSON.parse(res.body)
      return "#{body['title']} (Posted on #{body['published']})"
    end
    nil
  rescue
    nil
  end
  
end
