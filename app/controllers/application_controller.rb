class ApplicationController < ActionController::API
  include ExceptionHandler
  include Response
  include ReportsManager

  before_action :authorize_request
  attr_reader :current_user

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
