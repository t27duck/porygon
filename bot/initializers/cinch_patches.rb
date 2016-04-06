module LogReply
  def reply(text, prefix = false)
    super
    if @channel
      # Wait one second so the thread that is recording
      # the orignal input gets a chance to write to the
      # database. Not the best solution but should work
      # for most cases... I'm a monster.
      sleep 1

      RawChatLog.create!(
        channel:    @channel,
        nick:       bot.nick,
        host:       bot.host,
        message:    text,
        event:      :message,
        created_on: Time.now.utc
      )
    end
  end
end

Cinch::Message.prepend LogReply
