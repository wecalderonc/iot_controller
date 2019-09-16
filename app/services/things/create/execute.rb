module Things::Create
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,             with: Common::Operations::Validator.(:create, :thing)
    step :create,                 with: Things::Create::CreateThing.new
  end.Do
end
