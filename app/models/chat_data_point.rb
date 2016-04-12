class ChatDataPoint < ApplicationRecord
  validates :channel, :nick, :full_date, :day, :hour, :line_count,
    :word_count, presence: true

  def self.generate_data_points
    data = {}
    RawChatLog.unparsed.messages.find_each do |rcl|
      key = [
        rcl.channel,
        rcl.nick,
        rcl.created_on,
        rcl.created_at.day,
        rcl.created_at.hour
      ]

      data[key] ||= {
        line_count: 0,
        word_count: 0,
        quotes:     []
      }

      data[key][:line_count]  += 1
      data[key][:word_count]  += rcl.message.split(' ').size
      data[key][:quotes]      += [rcl.message]

      rcl.update_column(:parsed, true)
    end

    ChatDataPoint.transaction do
      data.each do |identifiers, stats|
        puts identifiers.inspect
        channel, nick, created_on, day, hour = identifiers
        point = ChatDataPoint.find_or_initialize_by(
          channel:    channel,
          nick:       nick,
          full_date:  created_on,
          hour:       hour,
          day:        day
        )
        point.line_count   += stats[:line_count]
        point.word_count   += stats[:word_count]
        point.random_quote = stats[:quotes].sample unless stats[:quotes].empty?

        point.save
      end
    end
  end
end
