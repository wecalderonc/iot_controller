require 'dry/transaction/operation'

class Users::Password::Recovery
  include Dry::Transaction::Operation

  def call(input)
    user = User.find_by(email: "#{input[:email]}.#{input[:format]}")

    if user
      UserMailer.with(user: user).recovery_email.deliver_now
      Success({ message: "Recovery Password Email Sended! Go to your inbox!" })
    else
      Failure Errors.general_error("User not found", self.class)
    end
  end
end
