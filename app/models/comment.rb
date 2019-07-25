class Comment < ApplicationRecord
  belongs_to :task
  has_one_attached :attachment

  validates :text, presence: true, length: { maximum: 256, minimum: 10 }
  validates :attachment, content_type: ['image/png', 'image/jpg', 'image/jpeg'], size: { less_than: 10.megabytes }
end
