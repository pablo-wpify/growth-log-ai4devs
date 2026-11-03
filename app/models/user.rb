class User < ApplicationRecord
  PASSWORD_MIN_LENGTH = 15

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :assignments, foreign_key: :leader_id, inverse_of: :leader, dependent: :restrict_with_exception

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validates :name, presence: true
  # has_secure_password ya valida el máximo de 72 bytes (límite de bcrypt).
  validates :password, length: { minimum: PASSWORD_MIN_LENGTH }, allow_nil: true

  scope :active, -> { where(deactivated_at: nil) }

  def active?
    deactivated_at.nil?
  end
end
