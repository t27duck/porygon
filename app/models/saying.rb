class Saying < ApplicationRecord
  has_many :responses, class_name: "SayingResponse", inverse_of: :saying,
    dependent: :delete_all

  accepts_nested_attributes_for :responses, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates :pattern, presence: true, uniqueness: true
  validates :trigger_percentage, presence: true, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 100,
    only_integer: true
  }

  scope :enabled, -> { where(enabled: true) }
end
