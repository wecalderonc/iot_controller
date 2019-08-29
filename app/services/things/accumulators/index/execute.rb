module Things::Accumulators::Index
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:get, :accumulator)
    step :get_thing,             with: Things::Get.new
    step :get_accumulators,      with: Things::Accumulators::Get.new
  end.Do
end
