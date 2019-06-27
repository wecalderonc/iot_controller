module Amazon::Iot::Shadows::Update
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,                     with: Common::Operations::Validator.(:update_state, :shadow)
    map  :build_payload,                  with: Amazon::Iot::Shadows::Update::BuildPayload.new
    step :update,                         with: Amazon::Iot::Api::Execute.new
  end.Do
end
