module Calculators::Prices
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:get_price, :thing)
    step :get_price,             with: Calculators::Prices::Get.new
  end.Do
end
