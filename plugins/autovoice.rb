class Autovoice
  include Cinch::Plugin
  listen_to :join

  def listen(m)
    return if m.user.nick == bot.nick
    m.channel.voice(m.user) if ["rawmeatcowboy", "nintendaan"].include?(m.user.nick.downcase)
  end
end
