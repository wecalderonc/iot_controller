require 'dry/transaction/operation'

class Calculators::Prices::Get
  include Dry::Transaction::Operation

  def call(input)
    unit = input[:unit].to_s
    price = Price.by_unit(unit)

    if price.present?
      counters_per_unit = input[:accumulator].my_units[unit].to_f # { liter: 200 }[:liter].to_f
      final_price = Base::Maths::RuleOfThree.(price.value, input[:accumulator].int_value, counters_per_unit)
      { accumulator: { int_value: 'tales' } }
      units_count = input[:accumulator].int_value * counters_per_unit
                    # accumulated_delta * counters_per_unit

      Success.new({ units_count: units_count, final_price: final_price })
    else
      Failure.new(Errors.general_error("There are any configured prices", self.class))
    end
  end
end
