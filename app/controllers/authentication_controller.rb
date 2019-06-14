class AuthenticationController < ApplicationController

  def authenticate_user
    request = AuthenticateUser.new.(params)
    if request.success?
      render json: request.success, status: :ok
    else
      render json: { errors: request.failure[:message] }, status: :unauthorized
    end
  end
end
