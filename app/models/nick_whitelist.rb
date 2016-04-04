class NickWhitelist < ApplicationRecord
  validates :nick, presence: true, uniqueness: true
  before_validation :downcase_nick

  def self.includes?(nick)
    pluck(:nick).include?(nick)
  end

  private ######################################################################

  # before_validation
  def downcase_nick
    self.nick = nick.downcase if nick.present?
  end
end
