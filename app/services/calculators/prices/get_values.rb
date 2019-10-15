require 'dry/transaction/operation'

class Calculators::Prices::GetValues
  include Dry::Transaction::Operation

  def call(input)
    if input[:value].present?
      input
    else
      input.merge(value: input[:accumulator].int_value)
    end
  end
end
