module Calculators::Prices
  GetPrice = -> input do
    last_acc = input[:thing].last_accumulators.last
    price = Price.by_unit(input[:unit]).value

    pp "precio por #{input[:unit]}: #{price}"
    pp "conteos = #{last_acc.int_value}"
    pp "conteos por unidad = #{input[:thing].units[input[:unit]]}"
    Dry::Monads::Success.new(price: price * (last_acc.int_value / input[:thing].units[input[:unit]]))
  end

  ConvertToCurrency = -> input do
    Dry::Monads::Success.new(input[:price])
  end

  #repensar este nombre
  _, ByThingUnit = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:get_price, :thing)
    step :get_price,             with: Calculators::Prices::GetPrice
    step :convert_to_currency,   with: Calculators::Prices::ConvertToCurrency
  end.Do
end
