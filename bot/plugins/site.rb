class Site
  include Cinch::Plugin

  def initialize(*args)
    super
    @last_story_urls ||= {}
  end

  match(/https?:\/\/w{0,3}\.?gonintendo\.com\/stories\/([a-z\-0-9]+)/i,
    use_prefix: false,
    strip_colors: true,
    method: :get_gonintendo_story)

  match(/https?:\/\/w{0,3}\.?goingsony\.com\/stories\/([a-z\-0-9]+)/i,
    use_prefix: false,
    strip_colors: true,
    method: :get_goingsony_story)

  timer (10 * 60), method: :check_sites

  def get_gonintendo_story(m, story_id)
    get_story(m, "https://gonintendo.com/porygon/story.json?id=#{story_id.to_i}&key=#{CONFIG["porygon_key"]}")
  end

  def get_goingsony_story(m, story_id)
    get_story(m, "https://goingsony.com/porygon/story.json?id=#{story_id.to_i}&key=#{CONFIG["porygon_key"]}")
  end

  def check_sites
    [
      {
        url: "https://gonintendo.com/porygon/top_stories.json?key=#{CONFIG["porygon_key"]}",
        channel: '#gonintendo',
        first_story_only: false
      },
      {
        url: "https://goingsony.com/porygon/top_stories.json?key=#{CONFIG["porygon_key"]}",
        channel: '#goingsony',
        first_story_only: false
      }
    ].each do |site|
      check_site(site)
    end
  end

  private ######################################################################

  def get_story(message, url)
    body = make_request(url)
    return if body.nil?
    reply = "#{body["title"]}"
    reply << " (Posted on #{body["published_at"]})"
    reply << " Rating: #{body["rating"]}"
    reply << " [+#{body["positive"].to_i} -#{body["negative"].to_i.abs}]"
    message.reply reply
  end

  def check_site(site)
    body = make_request(site[:url])
    return if body.nil?
    messages = build_messages(site, body['stories'])

    messages.each do |message|
      Channel(site[:channel]).send message
    end
  end

  def build_messages(site, stories)
    messages = []

    if @last_story_urls[site[:channel]].nil?
      set_last_story_urls(stories, site[:channel])
      return []
    end

    stories.each_with_index do |story, i|
      if !@last_story_urls[site[:channel]].include?(story['url'])
        break if site[:first_story_only] && i > 0
        messages << "New Top Story: #{story['title']} - #{story['url']}"
      end
    end

    set_last_story_urls(stories, site[:channel])
    messages
  end

  def set_last_story_urls(stories, channel)
    @last_story_urls[channel] = []
    stories.each do |story|
      @last_story_urls[channel] << story['url']
    end
  end

  def make_request(url)
    url = URI.parse(url)
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req) }
    return nil unless res.code == '200'
    JSON.parse(res.body)
  rescue
    nil
  end
end
