require 'dry/transaction/operation'

class Users::Get
  include Dry::Transaction::Operation

  def call(input)
    user = find_user(input)

    if user.present?
      Success input.merge(user: user)
    else
      Failure Errors.general_error("User not found", self.class)
    end
  end

  private

  def find_user(input)
      User.find_by(email: input[:email])
  end
end
