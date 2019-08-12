require 'dry/transaction'

class Users::Create::User
  include Dry::Transaction

  def call(input)
    user = User.new(input.except(:country_code))

    if user.save
      Success input.merge(user: user)
    else
      Failure Errors.general_error("Errors in saving process", self.class)
    end
  end
end
