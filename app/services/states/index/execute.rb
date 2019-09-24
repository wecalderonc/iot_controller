module States::Index
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,    with: Common::Operations::Validator.(:get, :state)
    step :find_country,  with: States::FindCountry.new
    map  :list_states,   with: States::Index::ListStates.new
  end.Do
end
