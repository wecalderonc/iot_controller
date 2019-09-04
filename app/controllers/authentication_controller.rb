class AuthenticationController < ApplicationController

  skip_before_action :authorize_request

  def authenticate_user
    request = Users::Authenticate::Execute.new.(authenticate_params)

    if request.success?
      render json: request.success, status: :ok
    else
      render json: { errors: request.failure[:message] }, status: :unauthorized
    end
  end

  private

  def authenticate_params
    params.permit(:email, :password).to_h.symbolize_keys
  end
end
