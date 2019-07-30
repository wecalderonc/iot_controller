module Calculators::Prices
  ConvertToCurrency = -> input do
    price = input[:price]
    money_object = Money.new(price, input[:original_currency])
    money_object.exchange_to(input[:currency]).fractional
  end

  _, Execute = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:get_price, :thing)
    step :get_last_acc,          with: Calculators::Prices::GetLastAccumulator.new
    step :get_price,             with: Calculators::Prices::Get.new
    map  :convert_to_currency,   with: Calculators::Prices::ConvertToCurrency
  end.Do
end
