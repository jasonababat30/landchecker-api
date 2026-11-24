require "rails_helper"

RSpec.describe PropertyChannel, type: :channel do
  it "subscribes to the properties stream" do
    subscribe

    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("properties")
  end
end
