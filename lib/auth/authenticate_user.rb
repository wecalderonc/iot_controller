require 'dry/transaction'
module Auth
  class AuthenticateUser
    include Dry::Transaction

    step :find_user
    step :validate_password
    map  :build_payload

    def find_user(input)
      user = User.find_by(email: input[:email])
      user.present? ? Success({ user: user, input_password: input[:password] }) : Failure(Errors.model_error("User not found", User))
    end

    def validate_password(input)
      if input[:user].valid_password?(input[:input_password])
        Success input[:user]
      else
        Failure Errors.failed_request(:unauthorized, "Invalid Username/Password")
      end
    end

    def build_payload(input)
      {
        auth_token: JsonWebToken.encode( { user_id: input.id } ),
        email:      input.email
      }
    end
  end
end
