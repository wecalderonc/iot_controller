require 'dry/transaction/operation'

class Users::Password::Update
  include Dry::Transaction::Operation

  def call(input)
    user = input[:user]

    if user.update(password: input[:password])
      Success input[:user]
    else
      Failure Errors.general_error(user.errors.messages, self.class)
    end
  end
end
