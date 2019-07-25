module Calculators::Prices
  #TODO: Replace for real currency conversion
  ConvertToCurrency = -> input do
    if ['COP', 'USD'].include? input[:currency]
      Dry::Monads::Success.new(input[:price])
    else
      Dry::Monads::Failure.new(Errors.general_error("The currency is not valid", self.class))
    end
  end

  _, Execute = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:get_price, :thing)
    step :get_last_acc,          with: Calculators::Prices::GetLastAccumulator.new
    step :get_price,             with: Calculators::Prices::Get.new
    step :convert_to_currency,   with: Calculators::Prices::ConvertToCurrency
  end.Do
end
