require "json"
require "oauth"

class Twitter
  def invoke(data)
    message = data[:message].to_s.strip
    if (message =~ /^%(twitter|tweet) @?\w+$/i) != nil
      return get_tweet_by_screen_name(get_screen_name(message))
    end
    if (message =~ /twitter.com\/.+status\/\d+$/i) != nil
      return get_tweet_by_status_id(get_status_id(message))
    end
  end

  private #####################################################################

  def get_status_id(message)
    /(\d+)$/i.match(message).to_s
  end

  def get_screen_name(message)
    /\w+$/i.match(message).to_s
  end

  def get_tweet_by_screen_name(screen_name)
    return nil if screen_name == ""
    res = access_token.request(:get, "http://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=#{screen_name}&count=1")
    return nil unless res.code == "200"
    body = Array(JSON.parse(res.body)).first
    "#{body["user"]["name"]} (@#{body["user"]["screen_name"]}) \"#{body["text"]}\""
  rescue
    nil
  end
 
  def get_tweet_by_status_id(tweet_id)
    return nil if tweet_id == ""
    res = access_token.request(:get, "https://api.twitter.com/1.1/statuses/show/#{tweet_id}.json")
    return nil unless res.code == "200"
    body = JSON.parse(res.body)
    "#{body["user"]["name"]} (@#{body["user"]["screen_name"]}) \"#{body["text"]}\""
  rescue
    nil
  end

  def access_token
    @access_token ||= get_access_token
  end

  def get_access_token
    oauth_token        = Settings.twitter['oauth_token']
    oauth_token_secret = Settings.twitter['oauth_token_secret']
    consumer_key       = Settings.twitter['consumer_key']
    consumer_secret    = Settings.twitter['consumer_secret']
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret,
      { :site => "http://api.twitter.com",
        :scheme => :header
      })
    # now create the access token object from passed values
    token_hash = { :oauth_token => oauth_token,
                   :oauth_token_secret => oauth_token_secret
                 }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
  end

end
