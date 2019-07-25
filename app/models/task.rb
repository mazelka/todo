class Task < ApplicationRecord
  belongs_to :project
  has_many :comments
  acts_as_list scope: :project
  scope :active, -> { where done: false }
  scope :done, -> { where done: true }

  validates :name, presence: true, uniqueness: true, length: { maximum: 50, minimum: 1 }
end
