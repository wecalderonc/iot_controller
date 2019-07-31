require 'dry/transaction/operation'

class Users::Create
  include Dry::Transaction::Operation

  def call(input)
    user = User.new(input[user_params])

    if user.save
      Success input.merge(user: user)
    else
      Failure Errors.general_error("Problems with saving", self.class)
    end
  end
end
