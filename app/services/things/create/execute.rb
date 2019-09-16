module Things::Create
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,             with: Common::Operations::Validator.(:create, :thing)
    step :create,                 with: Things::Create::Create.new
    step :create_relations        with: Things::Create::Relations.new
  end.Do
end
