class AuthenticationController < ApplicationController

  def authenticate_user
    user = User.find_by(email: params[:email])
    if user and user.valid_password?(params[:password])
      render json: payload(user)
    else
      render json: {errors: 'Invalid Username/Password'}, status: :unauthorized
    end
  end

  private

  def payload(user)
    return nil if not user and user.id
    {
      auth_token: JsonWebToken.encode( { user_id: user.id } ),
      email:      user.email
    }
  end
end
