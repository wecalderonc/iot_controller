module Cities::Index
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,  with: Common::Operations::Validator.(:get, :city)
    step :find_state,  with: Cities::FindState.new
    map  :list_states, with: Cities::Index::ListCities.new
  end.Do
end
