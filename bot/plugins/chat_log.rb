class ChatLog
  include Cinch::Plugin

  listen_to :message, method: :process_message, strip_colors: true
  listen_to :leaving, method: :process_leaving, strip_colors: true
  listen_to :join,    method: :process_join,    strip_colors: true

  def process_message(m)
    return unless m.channel?
    args            = build_common_log_args(m, m.user)
    args[:message]  = m.action? ? m.action_message : m.message
    args[:event]    = m.action? ? :action : :message
    log_message(args)
  end

  def process_leaving(m, _user)
    return unless m.channel?
    args            = build_common_log_args(m, m.user)
    args[:message]  = "left the room"
    args[:event]    = :part
    log_message(args)
  end

  def process_join(m)
    return unless m.channel?
    args            = build_common_log_args(m, m.user)
    args[:message]  = "joined the room"
    args[:event]    = :joined
    log_message(args)
  end

  private #####################################################################

  def build_common_log_args(message, user)
    {
      channel:  message.channel.name,
      nick:     user.nick,
      host:     user.host
    }
  end

  def log_message(channel:, nick:, host:, message:, event:)
    RawChatLog.create!(
      channel:    channel,
      nick:       nick,
      host:       host,
      message:    message,
      event:      event,
      created_on: Time.now.utc
    )
  end

end
