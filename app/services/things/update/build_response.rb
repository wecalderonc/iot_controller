require 'dry/transaction/operation'

class Things::Update::BuildResponse
  include Dry::Transaction::Operation

  def call(input)
    p input[:thing]

  end
end
