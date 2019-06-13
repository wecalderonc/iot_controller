require 'dry/transaction'
class AuthorizeApiRequest
  include Dry::Transaction

  step :validate_token
  step :decode_token
  step :find_user

  def validate_token(input)
    if input['Authorization'].present?
      Success input['Authorization']
    else
      Failure "Authorization not found in headers"
    end
  end

  def decode_token(input)
    result = JsonWebToken.decode(input).to_result
    if result.success?
      Success result.success["user_id"]
    else
      Failure "NotFound"
    end
  end

  def find_user(input)
    user = User.find_by(email: input)
    if user.present?
      Success({ user: user})
    else
      Failure(Errors.model_error("User not found", self.class))
    end
  end
end
