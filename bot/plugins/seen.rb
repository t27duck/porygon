class Seen
  include Cinch::Plugin
  include ActionView::Helpers::DateHelper

  listen_to :channel
  match(/seen ([^\s]+)\z/i, strip_colors: true, user_prefix: true)

  def listen(m)
    sa = SeenActivity.find_or_initialize_by(
      channel: m.channel.name,
      nick: m.user.nick.downcase
    )
    sa.message = m.message
    sa.message_will_change!
    sa.save
  end

  def execute(m, nick)
    return if m.user.nick.downcase == nick.downcase
    m.reply last_seen(m.channel.name, nick.downcase)
  end

  private ######################################################################

  def last_seen(channel, nick)
    sa = SeenActivity.find_by(channel: channel, nick: nick)

    if sa.nil?
      "Never seen #{nick} before, sorry!"
    else
      "I last saw #{sa.nick} saying something on #{sa.channel} about #{time_ago_in_words(sa.updated_at)} ago."
    end
  end
end
