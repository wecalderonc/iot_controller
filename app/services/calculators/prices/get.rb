require 'dry/transaction/operation'

class Calculators::Prices::Get
  include Dry::Transaction::Operation

  def call(input)
    unit = input[:unit].to_s
    price = Price.by_unit(unit)

    if price.present?
      counters_per_unit = input[:thing].units[unit]
      final_price = Base::Maths::RuleOfThree.(price.value, input[:last_acc].int_value, counters_per_unit)

      Success.new(input.merge(price: final_price))
    else
      Failure.new(Errors.general_error("There are any configured prices", self.class))
    end
  end
end
