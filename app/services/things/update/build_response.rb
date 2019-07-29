require 'dry/transaction/operation'

class Things::Update::BuildResponse
  include Dry::Transaction::Operation

  def call(input)
    input[:thing]
  end
end
