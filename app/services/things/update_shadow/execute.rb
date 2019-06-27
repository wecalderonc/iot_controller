module Things::UpdateShadow
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,       with: Common::Operations::Validator.(:update_state, :shadow)
    step :update_shadow,    with: Things::UpdateShadow::Update.new
  end.Do
end
