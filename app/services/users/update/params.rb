require 'dry/transaction'

class Users::Update::Params
  include Dry::Transaction

  def call(input)
    user = input[:user]

    if user.update(input)
      Success input
    else
      Failure Errors.general_error(user.errors.messages, self.class)
    end
  end
end
