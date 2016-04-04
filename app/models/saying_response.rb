class SayingResponse < ApplicationRecord
  belongs_to :saying, required: true

  validates :content, presence: true
end
