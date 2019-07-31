module Users::Create
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,            with: Common::Operations::Validator.(:create, :user)
    step :create,                with: Users::Create.new
    map  :build_response,        with: Users::Create::BuildResponse.new
  end.Do
end


