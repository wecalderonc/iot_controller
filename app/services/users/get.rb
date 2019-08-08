require 'dry/transaction/operation'

class Users::Get
  include Dry::Transaction::Operation

  def call(input)
    user = User.find_by(email: input[:email])

    if user.present?
      Success input.merge(user: user)
    else
      Failure Errors.general_error("The user #{input[:first_name]} does not exist", self.class)
    end
  end
end
