module Downlinks::Create
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,                     with: Common::Operations::Validator.(:create, :downlink)
    #map  :build_params,                   with: Addresses::Create::BuildParams.new
    step :update_shadow_desired_state,    with: Amazon::Iotdata::UpdateShadowDesiredState.new
  end.Do
end
