require 'dry/transaction'

class Users::VerificationCode::AssignVerificationCode
  include Dry::Transaction

  def call(input)
    user = input[:user]

    user.assign_verification_code

    user
  end
end
