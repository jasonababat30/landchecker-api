module Authenticatable
  extend ActiveSupport::Concern

  included do
    attr_reader :current_user
  end

  private

  def authenticate_request!
    header = request.headers["Authorization"]
    token = header&.match(/\ABearer (.+)\z/)&.captures&.first

    unless token
      return render json: {
        error: "Authentication required"
      }, status: :unauthorized
    end

    payload = JWT.decode(
      token,
      Rails.application.secret_key_base,
      true,
      algorithm: "HS256"
    ).first

    @current_user = User.find(payload["sub"])
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: {
      error: "Invalid or expired token"
    }, status: :unauthorized
  end
end
