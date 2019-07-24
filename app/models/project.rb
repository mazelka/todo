class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, -> { order(position: :asc) }

  validates :name, presence: true, length: { maximum: 72, minimum: 1 }
end
