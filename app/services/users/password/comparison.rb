require 'dry/transaction/operation'

class Users::Password::Comparison
  include Dry::Transaction::Operation

  def call(input)
    user = User.find_by(password: input[:current_password], email: "#{input[:email]}.#{input[:format]}")

    if user.email.eql?("#{input[:email]}.#{input[:format]}")
      Success input.merge(user: user)
    else
      Failure Errors.general_error("Current Password is incorrect", self.class)
    end
  end
end
