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
end
