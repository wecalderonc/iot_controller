require 'dry/transaction/operation'

class Shadows::Update::BuildResponse
  include Dry::Transaction::Operation

  def call(input)
    {
      payload: input[:payload],
      action: input[:action],
      type: input[:type],
      thing_name: input[:thing_name]
    }
  end
end
