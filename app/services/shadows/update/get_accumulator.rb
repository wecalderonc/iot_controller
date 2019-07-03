require 'dry/transaction/operation'

class Shadows::Update::GetAccumulator
  include Dry::Transaction::Operation

  def call(input)
    last_acc = input[:thing].last_accumulators

    if last_acc.present?
      Success input.merge(last_accumulators: last_acc.value)
    else
      Failure Errors.general_error("There are not accumulators", self.class)
    end
  end
end
