# app/controllers/concerns/response.rb
module Response
  include ActionController::MimeResponds

  def json_response(object, status = :ok, serializer = nil)
    p object
    render json: object, status: status, serializer: serializer
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
      render json: response.success[:user], status: :ok, serializer: UsersSerializer
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
      failure_response(response, :not_found)
    end
  end

  def failure_response(data, status)
    message, code = data.failure.values_at(:message, :code)

    json_response({ errors: message, code: code}, status)
  end

  private

  def index_resolver(model, params)
    resolver = "#{Utils.camelize_symbol(model)}::Index::Execute".constantize
    resolver.new.(params)
  end
end
