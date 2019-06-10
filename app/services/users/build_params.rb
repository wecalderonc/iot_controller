require 'dry/transaction/operation'

class Users::BuildParams
  include Dry::Transaction::Operation

  def call(input)
    input
  end
end
