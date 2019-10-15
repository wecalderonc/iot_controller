module Locations
  BuildResponse = -> input do
    input[:location]
  end

  _, Execute = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:get, :location)
    step :get_thing,             with: Things::Get.new
    step :get_location,          with: Locations::GetLocation.new
    map  :build_response,        with: BuildResponse
  end.Do
end
