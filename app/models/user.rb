class User < ApplicationRecord
  has_secure_password

  before_save :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.freeze

  validates :password, presence: true, length: { maximum: 72, minimum: 8 }, allow_blank: false
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 63 }, format: { with: VALID_EMAIL_REGEX }
  validates :username, presence: true, uniqueness: true, length: { maximum: 50, minimum: 3 }

  def downcase_email
    self.email = email.to_s.downcase
  end
end
