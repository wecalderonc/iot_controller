# app/controllers/concerns/response.rb
module Response
  include ActionController::MimeResponds

  def json_response(object, status = :ok)
    render json: object, status: status
  end

  def csv_response(data, filename)
    respond_to do |format|
      format.all { send_data data, filename: "#{filename}-#{Date.today}.csv" }
    end
  end

  def build_confirm_email_response(response)
    if response.success?
      json_response({ message: response.success }, :ok)
    else
      json_response({ message: response.failure[:message] }, :not_found)
    end
  end

  def default_show_response(response)
    if response.success?
      render json: response.success, status: :ok, serializer: UsersSerializer
    else
      json_response({ message: response.failure[:message] }, :not_found)
    end
  end
end
