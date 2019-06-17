module ExceptionHandler
  extend ActiveSupport::Concern

  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class MissingToken < StandardError; end

  included do
    rescue_from ExceptionHandler::DecodeError do |_error|
      render json: {
        message: "Access denied!. Invalid token supplied."
      }, status: :unauthorized
    end

    rescue_from ExceptionHandler::ExpiredSignature do |_error|
      render json: {
        message: "Access denied!. Token has expired."
      }, status: :unauthorized
    end

    rescue_from ExceptionHandler::MissingToken do |_error|
      render json: {
        message: "Access denied!. Token is missing."
      }, status: :unauthorized
    end

    rescue_from Neo4j::ActiveNode::Labels::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from Neo4j::ActiveNode::Persistence::RecordInvalidError do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end
end
