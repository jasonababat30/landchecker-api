properties = [
  { title: "Modern Family House", price: 450_000, bedrooms: 3, property_type: "house", status: "available" },
  { title: "City Center Apartment", price: 180_000, bedrooms: 2, property_type: "apartment", status: "available" },
  { title: "Cozy Starter Home", price: 220_000, bedrooms: 2, property_type: "house", status: "available" },
  { title: "Luxury Townhouse", price: 650_000, bedrooms: 4, property_type: "townhouse", status: "available" },
  { title: "Studio City Apartment", price: 95_000, bedrooms: 1, property_type: "apartment", status: "available" },
  { title: "Spacious Family Home", price: 520_000, bedrooms: 4, property_type: "house", status: "available" },
  { title: "Riverside Townhouse", price: 380_000, bedrooms: 3, property_type: "townhouse", status: "available" },
  { title: "Compact Urban Flat", price: 140_000, bedrooms: 1, property_type: "apartment", status: "available" },
  { title: "Garden House", price: 310_000, bedrooms: 3, property_type: "house", status: "available" },
  { title: "Premium Apartment", price: 420_000, bedrooms: 3, property_type: "apartment", status: "available" },
  { title: "Sold Family Property", price: 290_000, bedrooms: 3, property_type: "house", status: "sold" },
  { title: "Sold Townhouse", price: 350_000, bedrooms: 2, property_type: "townhouse", status: "sold" }
]

properties.each do |attributes|
  property = Property.find_or_initialize_by(title: attributes[:title])
  property.assign_attributes(attributes)
  property.save!
end

puts "Seeded #{properties.size} properties."
