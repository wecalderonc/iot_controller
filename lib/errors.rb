module Errors

  MergeErrorType = -> format, type do
    format.tap do |error|
      Custom::Logger.error(error.merge(type: type))
    end
  end

  def self.failed_request(status, message)
    format = { status: status, message: message }
    MergeErrorType.(format, :request)
  end

  def self.general_error(message, location, extra: {})
    format = { message: message, location: location, extra: extra }
    MergeErrorType.(format, :general)
  end

  def self.model_error(error, model, extra: {})
    format = { message: error, model: model, extra: extra }
    MergeErrorType.(format, :model)
  end
end
