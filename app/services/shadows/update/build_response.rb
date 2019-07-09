require 'dry/transaction/operation'

class Shadows::Update::BuildResponse
  include Dry::Transaction::Operation

  def call(input)
    {
      payload: input[:payload],
      input_method: input[:input_method],
      value: input[:value],
      action_type: input[:action_type],
      thing_name: input[:thing_name]
    }
  end
end
