require 'dry/transaction/operation'

class Users::Get
  include Dry::Transaction::Operation

  def call(input)
    user = find_user(input)

    if user.present?
      Success input.merge(user: user)
    else
      Failure Errors.build("User not found", self.class, :not_found)
    end
  end

  private

  def find_user(input)
    options = {
      true => User.find_by(email: "#{input[:email]}.#{input[:format]}"),
      false => User.find_by(email: input[:email])
    }

    options[input[:format].present?]
  end
end
