require 'dry/transaction'
module Auth
  class AuthenticateUser
    include Dry::Transaction

    step :find_user
    step :validate_password
    map  :consolidate_answer

    def find_user(input)
      user = User.find_by(email: input[:email])
      user.present? ? Success(user) : Failure(Errors.model_error("User not found", User))
    end

    def validate_password(input)
      input.validate_password?(input[:password]) ? Success(input) : Failure(Errors.failed_request(:unauthorized, "User not found"))
    end

    def consolidate_answer(input)
      input.bind do |api_user|
        api_user.fmap { |user| payload(user) }
      end
      .or(Errors.failed_request(:unauthorized, "Invalid Username/Password"))
    end

    private
 
    def payload(user)
      {
        auth_token: JsonWebToken.encode( { user_id: user.id } ),
        email:      user.email
      }
    end
  end
end
