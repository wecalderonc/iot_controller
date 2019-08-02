require 'dry/transaction/operation'

class Users::Create::Create
  include Dry::Transaction::Operation

  def call(input)
    user = User.new(input)

    if user.save
      Success input.merge(user: user)
    else
      Failure Errors.general_error("Errors in saving process", self.class)
    end
  end
end
