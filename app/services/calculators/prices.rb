module Calculators::Prices
  GetPrice = -> input do
    last_acc = input[:last_acc]
    price = Price.by_unit(input[:unit])

    if price.present?
      aja = price.value * (last_acc.int_value / input[:thing].units[input[:unit]])
      input.merge!(price: aja)
      Dry::Monads::Success.new(input)
    else
      Dry::Monads::Failure.new(Errors.general_error("There are any configured prices", self.class))
    end
  end

  GetLastAccumulators = -> input do
    last_acc = input[:thing].last_accumulators.last
    if last_acc.present?
      input.merge!(last_acc: last_acc)
      Dry::Monads::Success.new(input)
    else
      Dry::Monads::Failure.new(Errors.general_error("No acc", self.class))
    end
  end

  ConvertToCurrency = -> input do
    if ['COP', 'USD'].include? input[:currency]
      Dry::Monads::Success.new(input[:price])
    else
      Dry::Monads::Failure.new(Errors.general_error("The currency is not valid", self.class))
    end
  end

  #repensar este nombre
  _, ByThingUnit = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:get_price, :thing)
    step :get_last_acc,          with: Calculators::Prices::GetLastAccumulators
    step :get_price,             with: Calculators::Prices::GetPrice
    step :convert_to_currency,   with: Calculators::Prices::ConvertToCurrency
  end.Do
end
