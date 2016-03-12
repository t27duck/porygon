class RawChatLog < ActiveRecord::Base
  enum event: [ :message, :action, :join, :part ]
  validates :channel, :nick, :host, :message, :event, presence: true
end
