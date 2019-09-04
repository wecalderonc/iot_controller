require 'dry/transaction/operation'

class Users::Authenticate::FindUser
  include Dry::Transaction::Operation

  def call(input)
    user = User.find_by(email: input[:email])

    if user.present?
      Success input.merge(user: user)
    else
      Failure Errors.service_error("User not found", 10104, self.class)
    end
  end
end
