require "rails_helper"

RSpec.describe Property, type: :model do
  describe "Action Cable broadcasts" do
    it "broadcasts a property update after its price changes" do
      property = Property.create!(
        title: "Test Family House",
        price: 450_000,
        bedrooms: 3,
        property_type: "house",
        status: "available"
      )

      expect(ActionCable.server).to receive(:broadcast).with(
        "properties",
        hash_including(
          event: "property_updated",
          property: hash_including(
            id: property.id,
            price: property.price + 1_000
          )
        )
      )

      property.update!(price: property.price + 1_000)
    end
  end
end
