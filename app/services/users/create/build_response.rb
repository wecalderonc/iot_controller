require 'dry/transaction/operation'

class Users::Create::BuildResponse
  include Dry::Transaction::Operation

  def call(input)
    input[:user]
  end
end
