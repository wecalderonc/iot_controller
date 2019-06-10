require 'dry/transaction'
module Auth
  class AuthenticateUser
    include Dry::Transaction

    step :find_user
    step :validate_password
    map  :build_payload

    def find_user(input)
      user = User.find_by(email: input[:email])
      if user.present?
        Success({ user: user, input_password: input[:password] })
      else
        Failure(Errors.model_error("User not found", self.class))
      end
    end

    def validate_password(input)
      if input[:user].valid_password?(input[:input_password])
        Success input[:user]
      else
        Failure Errors.failed_request(:unauthorized, "Invalid Username/Password")
      end
    end

    def build_payload(user)
      {
        auth_token: JsonWebToken.encode( { user_id: user.id } ),
        email:      user.email
      }
    end
  end
end
