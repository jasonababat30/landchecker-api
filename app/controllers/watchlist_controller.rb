class WatchlistController < ApplicationController
  include Authenticatable

  before_action :authenticate_request!

  def index
    properties = current_user.saved_properties
      .order(created_at: :desc, id: :desc)

    render json: { data: properties }
  end

  def create
    property = Property.find_by(
      id: params[:property_id],
      status: "available"
    )

    unless property
      return render json: {
        error: "Property not found"
      }, status: :not_found
    end

    watchlist_item = current_user.watchlist_items.new(
      property: property
    )

    if watchlist_item.save
      render json: {
        data: property
      }, status: :created
    else
      render json: {
        errors: watchlist_item.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    watchlist_item = current_user.watchlist_items.find_by(
      property_id: params[:property_id]
    )

    unless watchlist_item
      return render json: {
        error: "Property not found in your watchlist"
      }, status: :not_found
    end

    watchlist_item.destroy!

    head :no_content
  end
end
