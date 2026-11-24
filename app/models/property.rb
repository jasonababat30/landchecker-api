class Property < ApplicationRecord
  has_many :watchlist_items, dependent: :destroy
  has_many :saved_by_users,
           through: :watchlist_items,
           source: :user

  PROPERTY_TYPES = %w[house apartment townhouse].freeze
  STATUSES = %w[available sold].freeze

  validates :title, presence: true
  validates :price,
            numericality: { greater_than_or_equal_to: 0 }
  validates :bedrooms,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }
  validates :property_type, inclusion: { in: PROPERTY_TYPES }
  validates :status, inclusion: { in: STATUSES }


  after_commit :broadcast_property_update, on: [ :create, :update ]

  private

  def broadcast_property_update
    ActionCable.server.broadcast(
      "properties",
      {
        event: "property_updated",
        property: {
          id: id,
          title: title,
          price: price,
          bedrooms: bedrooms,
          property_type: property_type,
          status: status,
          created_at: created_at
        }
      }
    )
  end
end
