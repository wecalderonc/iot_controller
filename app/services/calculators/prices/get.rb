require 'dry/transaction/operation'

class Calculators::Prices::Get
  include Dry::Transaction::Operation

  def call(input)
    price = Price.by_unit(input[:unit])

    if price.present?
      counters_per_unit = input[:thing].units[input[:unit]]
      final_price = price.value * (input[:last_acc].int_value / counters_per_unit)

      Success.new(input.merge(price: final_price))
    else
      Failure.new(Errors.general_error("There are any configured prices", self.class))
    end
  end
end
