require 'dry/monads'

class Users::Confirmation
  extend Dry::Monads[:result]

  def self.verification_code(params)
    user = User.find_by(verification_code: params[:token])

    if user
      user.email_activate
      Success message: "Email Confirmed! Thanks!"
    else
      Failure Errors.general_error("Token expired or incorrect - User not found", self.class)
    end
  end
end
