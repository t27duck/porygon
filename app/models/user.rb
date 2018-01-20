class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable,
  # :recoverable, and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  def email_required?
    false
  end

  alias_method :email_changed?, :email_required?
  alias_method :will_save_change_to_email?, :email_required?
end
