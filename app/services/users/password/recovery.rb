require 'dry/monads'

class Users::Password::Recovery
  include Dry::Monads[:maybe]
  include Dry::Monads[:result]

  def call(input)
    user = User.find_by(email: input[:email])

    Maybe(user)
      .bind do
        UserMailer.with(user: user).recovery_email.deliver_now
        Success message: "Recovery Password Email Sent! Go to your inbox!"
      end
      .or { Failure Errors.build("User not found", self.class, :not_found) }
  end
end
