class ApplicationController < ActionController::API
  include ExceptionHandler
  include Response
  include ReportsManager
  include LocationHandler

  before_action :authorize_request
  attr_reader :current_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { message: 'Access Denied: '  + exception.message }, status: :forbidden }
      format.html { render json: { message: 'Access Denied: '  + exception.message }, status: :forbidden }
    end
  end

  private

  def authorize_request
    @current_user = AuthorizeApiRequest.new.call(request.headers)

    if @current_user.success?
      @current_user.success
    else
      raise(ExceptionHandler::MissingToken)
    end
  end
end
