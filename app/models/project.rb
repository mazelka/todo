class Project < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 72, minimum: 1 }
end
