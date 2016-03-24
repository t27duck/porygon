class RawChatLog < ActiveRecord::Base
  enum event: [ :message, :action, :join, :part ]
  validates :channel, :nick, :host, :message,
    :event, :created_on, presence: true
end
