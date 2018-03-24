class RawChatLog < ApplicationRecord
  enum event: [ :message, :action, :joined, :part ]
  validates :channel, :nick, :host, :message,
    :event, :created_on, presence: true
  before_save :downcase_nick

  scope :unparsed, -> { where(parsed: false) }
  scope :messages, -> { where(event: :message) }

  private ######################################################################

  def downcase_nick
    self.nick = nick.downcase
  end
end
