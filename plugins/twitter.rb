require 'json'
require 'oauth'
require 'htmlentities'

class Twitter
  include Cinch::Plugin

  match /twitter.com\/.+status\/(\d+)/i, use_prefix: false, strip_colors: true

  def execute(m, status_id)
    return unless CONFIG['twitter']
    res = access_token.request(:get, "https://api.twitter.com/1.1/statuses/show/#{status_id}.json")
    return unless res.code == '200'
    body = JSON.parse(res.body)
    tweet_body = HTMLEntities.new.decode(body['text']).split("\n").join(' ')
    m.reply "#{body['user']['name']} (@#{body['user']['screen_name']}) - #{tweet_body}"
  rescue
  end

  def access_token
    @access_token ||= get_access_token
  end

  def get_access_token
    oauth_token        = CONFIG['twitter']['oauth_token']
    oauth_token_secret = CONFIG['twitter']['oauth_token_secret']
    consumer_key       = CONFIG['twitter']['consumer_key']
    consumer_secret    = CONFIG['twitter']['consumer_secret']
    consumer = OAuth::Consumer.new(
      consumer_key,
      consumer_secret,
      {
        site: 'http://api.twitter.com',
        scheme: :header
      }
    )
    token_hash = {
      oauth_token: oauth_token,
      oauth_token_secret: oauth_token_secret
    }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
  end
end
