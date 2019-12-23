module Errors

  CODE_ERRORS = {
    not_found: '10104'
  }

  MergeErrorType = -> format, type do
    format.tap do |error|
      Custom::Logger.error(error.merge(type: type))
    end
  end

  def self.failed_request(status, message)
    format = { status: status, message: message }
    MergeErrorType.(format, :request)
  end

  def self.general_error(message, location, extra: {}, code: 10101)
    format = { message: message, location: location, extra: extra, code: code, error: message }
    MergeErrorType.(format, :general)
  end

  def self.model_error(error, model, extra: {})
    format = { message: error, model: model, extra: extra }
    MergeErrorType.(format, :model)
  end

  def self.service_error(error, code, location)
    format = { message: error, code: code, location: location }
    MergeErrorType.(format, :service)
  end

  def self.build(error, location, code)
    format = { error: error, code: CODE_ERRORS[code], location: location, message: error }

    MergeErrorType.(format, :general)
  end
end
