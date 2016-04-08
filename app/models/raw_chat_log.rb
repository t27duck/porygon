class RawChatLog < ApplicationRecord
  enum event: [ :message, :action, :join, :part ]
  validates :channel, :nick, :host, :message,
    :event, :created_on, presence: true
  before_save :downcase_nick

  private ######################################################################

  def downcase_nick
    self.nick = nick.downcase
  end
end
