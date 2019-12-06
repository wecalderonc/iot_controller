require 'dry/monads'

class Users::Confirm
  include Dry::Monads[:maybe]
  include Dry::Monads[:result]

  def call(verification_code)
    user = User.find_by(verification_code: verification_code)

    Maybe(user)
      .bind do
        user.activate
        Success  message: "Email Confirmed! Thanks!"
      end
      .or { Failure Errors.build("Token expired or incorrect - User not found", self.class, :not_found) }
  end
end
