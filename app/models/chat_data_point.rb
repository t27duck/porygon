class ChatDataPoint < ApplicationRecord
  validates :channel, :nick, :full_date, :day, :hour, :line_count,
    :word_count, presence: true
end
