require 'dry/transaction'

class Users::Authenticate::ValidatePassword
  include Dry::Transaction

  def call(input)
    if input[:user].valid_password?(input[:password])
      Success input[:user]
    else
      Failure Errors.service_error("Invalid Username/Password", 10105, self.class)
    end
  end
end
