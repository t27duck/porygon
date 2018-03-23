require 'yt'

class Youtube
  include Cinch::Plugin
  include ActiveSupport::NumberHelper

  if CONFIG['youtube']
    Yt.configure do |config|
      config.api_key = CONFIG['youtube']
    end
  end

  match(/https?\:\/\/w{0,3}\.?youtube.com\/watch\?v=([\w-]+)/i, strip_colors: true, use_prefix: false, method: :standard_url)
  match(/https?\:\/\/w{0,3}\.?youtu.be\/([\w-]+)/i, strip_colors: true, use_prefix: false, method: :short_url)

  def standard_url(m, id)
    return unless CONFIG['youtube']
    m.reply fetch(id)
  rescue => e
    puts e.message
  end

  def short_url(m, id)
    return unless CONFIG['youtube']
    m.reply fetch(id.gsub(/\?.*\z/, ''))
  rescue => e
    puts e.message
  end

  private ######################################################################

  def fetch(id)
    video = Yt::Video.new id: id
    title = video.title
    channel = video.channel_title
    length = video.length.gsub(/\A00\:/, '')
    like = video.like_count
    dislike = video.dislike_count
    rating = ((like.to_f/(like+dislike)) * 100).round(2)

    output = "YouTube - #{title} (#{length}) ‹#{channel}› - Rating: #{rating}%"
    output += " [+#{number_to_delimited(like)}, -#{number_to_delimited(dislike)}]"

    return output
  end
end
