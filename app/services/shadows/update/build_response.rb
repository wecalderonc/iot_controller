require 'dry/transaction/operation'

class Shadows::Update::BuildResponse
  include Dry::Transaction::Operation

  def call(input)
    {
      payload: input[:payload],
      input_method: input[:input_method],
      value: input[:value],
      action: input[:action],
      thing_name: input[:thing_name]
    }
  end
end
