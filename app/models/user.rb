class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable,
  # :recoverable, and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
