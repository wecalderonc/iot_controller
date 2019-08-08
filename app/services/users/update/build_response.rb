require 'dry/transaction/operation'

class Users::Update::BuildResponse
  include Dry::Transaction::Operation

  def call(input)
    input[:user]
  end
end
