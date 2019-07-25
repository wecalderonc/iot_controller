require 'dry/transaction/operation'

class Calculators::Prices::GetLastAccumulator
  include Dry::Transaction::Operation

  def call(input)
    last_acc = input[:thing].last_accumulators.last

    if last_acc.present?
      Success.new(input.merge(last_acc: last_acc))
    else
      Failure.new(Errors.general_error("There are not accumulators", self.class))
    end
  end
end
