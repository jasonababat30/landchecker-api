
class AuthController < ApplicationController
  def register
    user = User.new(user_params)

    if user.save
      render json: {
        user: { id: user.id, email: user.email },
        token: generate_token(user)
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: normalized_email)

    if user&.authenticate(params[:password])
      render json: {
        user: { id: user.id, email: user.email },
        token: generate_token(user)
      }
    else
      render json: {
        error: "Invalid email or password"
      }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def normalized_email
    params[:email].to_s.strip.downcase
  end

  def generate_token(user)
    payload = {
      sub: user.id,
      exp: 24.hours.from_now.to_i
    }

    JWT.encode(
      payload,
      Rails.application.secret_key_base,
      "HS256"
    )
  end
end
