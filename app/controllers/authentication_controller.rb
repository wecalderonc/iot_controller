class AuthenticationController < ApplicationController

  skip_before_action :authorize_request

  def authenticate_user
    request = Users::Authenticate::Execute.new.(authenticate_params)

    if request.success?
      json_response(request.success, :ok)
    else
      failure_response(request, :unauthorized)
    end
  end

  private

  def authenticate_params
    params.permit(:email, :password).to_h.symbolize_keys
  end
end
