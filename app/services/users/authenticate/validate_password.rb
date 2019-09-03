require 'dry/transaction'

class Users::Authenticate::ValidatePassword
  include Dry::Transaction

  def call(input)
    if input[:user].valid_password?(input[:password])
      Success input[:user]
    else
      Failure Errors.failed_request(:unauthorized, "Invalid Username/Password")
    end
  end
end
