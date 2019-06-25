module Downlinks::Create
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,         with: Common::Operations::Validator.(:create, :address)
    map  :build_params,       with: Addresses::Create::BuildParams.new
    step :persist,            with: Common::Operations::Persist.new(object_type: :address)
  end.Do
end
