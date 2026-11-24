class User < ApplicationRecord
  has_secure_password

  has_many :watchlist_items, dependent: :destroy
  has_many :saved_properties,
           through: :watchlist_items,
           source: :property

  before_validation :normalize_email

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
          length: { minimum: 8 },
          if: -> { password.present? }

  private

  def normalize_email
    self.email = email.strip.downcase if email.present?
  end
end
