require "rails_helper"

RSpec.describe "Properties API", type: :request do
  describe "GET /properties" do
    before do
      Property.create!(
        title: "Family House",
        price: 450_000,
        bedrooms: 3,
        property_type: "house",
        status: "available"
      )

      Property.create!(
        title: "City Apartment",
        price: 180_000,
        bedrooms: 2,
        property_type: "apartment",
        status: "available"
      )

      Property.create!(
        title: "Sold House",
        price: 300_000,
        bedrooms: 3,
        property_type: "house",
        status: "sold"
      )
    end

    it "returns only available properties" do
      get "/properties"

      expect(response).to have_http_status(:ok)

      titles = response.parsed_body["data"].map do |property|
        property["title"]
      end

      expect(titles).to contain_exactly(
        "Family House",
        "City Apartment"
      )
    end

    it "filters properties by type" do
      get "/properties", params: { property_type: "house" }

      expect(response).to have_http_status(:ok)

      titles = response.parsed_body["data"].map do |property|
        property["title"]
      end

      expect(titles).to eq([ "Family House" ])
    end

    it "rejects an invalid property type" do
      get "/properties", params: { property_type: "castle" }

      expect(response).to have_http_status(:bad_request)
    end

    it "paginates results" do
      get "/properties", params: { page: 1, per_page: 1 }

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body["data"].size).to eq(1)
      expect(response.parsed_body["pagination"]["per_page"]).to eq(1)
      expect(response.parsed_body["pagination"]["total"]).to eq(2)
    end
  end
end
