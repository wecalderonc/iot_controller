require 'dry/transaction/operation'

class Users::Get
  include Dry::Transaction::Operation

  def call(input)
    user = User.find_by(email: "#{input[:email]}.#{input[:format]}")

    if user.present?
      Success input.merge(user: user)
    else
      Failure Errors.general_error("User not found", self.class)
    end
  end
end
