class AuthenticationController < ApplicationController

  skip_before_action :authorize_request

  def authenticate_user
    request = Users::Authenticate::Execute.new.(authenticate_params)

    if request.success?
      json_response(request.success, :ok)
    else
      message, code = request.failure.values_at(:message, :code)

      json_response({ errors: message, code: code }, :unauthorized)
    end
  end

  private

  def authenticate_params
    params.permit(:email, :password).to_h.symbolize_keys
  end
end
