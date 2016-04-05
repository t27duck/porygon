module LogReply
  def reply(text, prefix = false)
    if @channel
      RawChatLog.create!(
        channel:    @channel,
        nick:       bot.nick,
        host:       bot.host,
        message:    text,
        event:      :message,
        created_on: Time.now.utc
      )
    end

    super
  end
end

module Cinch
  class Message
    prepend LogReply
  end
end
