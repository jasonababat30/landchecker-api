
class PropertiesController < ApplicationController
  def index
    filters = validated_filters

    return if performed?

    properties = Property.where(status: "available")

    properties = properties.where("price >= ?", filters[:min_price]) if filters[:min_price]
    properties = properties.where("price <= ?", filters[:max_price]) if filters[:max_price]
    properties = properties.where(bedrooms: filters[:bedrooms]) if filters[:bedrooms]
    properties = properties.where(property_type: filters[:property_type]) if filters[:property_type]

    total = properties.count
    page = filters[:page]
    per_page = filters[:per_page]

    properties = properties
      .order(created_at: :desc, id: :desc)
      .offset((page - 1) * per_page)
      .limit(per_page)

    render json: {
      data: properties,
      pagination: {
        page: page,
        per_page: per_page,
        total: total,
        total_pages: (total.to_f / per_page).ceil
      }
    }
  end

  private

  def validated_filters
    filters = {
      min_price: parse_number(:min_price),
      max_price: parse_number(:max_price),
      bedrooms: parse_integer(:bedrooms),
      property_type: params[:property_type].presence,
      page: parse_integer(:page, default: 1),
      per_page: parse_integer(:per_page, default: 10)
    }

    return filters if performed?

    if filters[:min_price] && filters[:max_price] &&
       filters[:min_price] > filters[:max_price]
      return render_error("min_price cannot exceed max_price")
    end

    if filters[:bedrooms]&.negative?
      return render_error("bedrooms must be zero or greater")
    end

    if filters[:property_type] &&
       !Property::PROPERTY_TYPES.include?(filters[:property_type])
      return render_error("Invalid property_type")
    end

    if filters[:page] < 1
      return render_error("page must be at least 1")
    end

    if filters[:per_page] < 1 || filters[:per_page] > 50
      return render_error("per_page must be between 1 and 50")
    end

    filters
  end

  def parse_number(key)
    return nil if params[key].blank?

    value = Float(params[key])
    return render_error("#{key} must be zero or greater") if value.negative?

    value
  rescue ArgumentError, TypeError
    render_error("#{key} must be a valid number")
  end

  def parse_integer(key, default: nil)
    return default if params[key].blank? && !default.nil?
    return nil if params[key].blank?

    value = Integer(params[key], 10)
    return render_error("#{key} must be a valid integer") if value.negative? && key != :bedrooms

    value
  rescue ArgumentError, TypeError
    render_error("#{key} must be a valid integer")
  end

  def render_error(message)
    render json: { error: message }, status: :bad_request
  end
end
