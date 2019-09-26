# app/controllers/concerns/response.rb
module Response
  include ActionController::MimeResponds

  def json_response(object, status = :ok, serializer = nil)
    render json: object, status: status, serializer: serializer
  end

  def csv_report_response(input)
    type = Utils.camelize_symbol(input[:model])
    data = "Reports::#{type}s::Index::CsvFormat".constantize.new.(input)

    respond_to do |format|
      if data.success?
        format.all { send_data data.success, filename: "Device-#{input[:model]}", content_type: "text/csv" }
      else
        message, code = data.failure.values_at(:message, :code)
       
        json_response({ errors: message, code: code}, :not_found)
      end
    end
  end

  def json_report_response(input)
    type = Utils.camelize_symbol(input[:model])
    data = "Reports::#{type}s::Index::JsonFormat".constantize.new.(input)
    serializer = "#{Utils.to_constant(model)}Serializer".constantize

    if data.success?
      render json: data.success, status: :ok, each_serializer: serializer
    else
      message, code = data.failure.values_at(:message, :code)
     
      json_response({ errors: message, code: code}, :not_found)
    end
  end

  def build_confirm_email_response(response)
    if response.success?
      json_response({ message: response.success }, :ok)
    else
      json_response({ errors: response.failure[:message] }, :not_found)
    end
  end

  def default_show_response(response)
    if response.success?
      render json: response.success, status: :ok, serializer: UsersSerializer
    else
      json_response({ message: response.failure[:message] }, :not_found)
    end
  end

  def index_response_handler(model, params)
    response = index_resolver(model, params)

    if response.success?
      serializer = "#{Utils.to_constant(model)}Serializer".constantize

      render json: response.success, status: :ok, each_serializer:  serializer
    else
      message, code = response.failure.values_at(:message, :code)

      json_response({ errors: message, code: code}, :not_found)
    end
  end

  private

  def index_resolver(model, params)
    resolver = "#{Utils.camelize_symbol(model)}::Index::Execute".constantize
    resolver.new.(params)
  end
end
