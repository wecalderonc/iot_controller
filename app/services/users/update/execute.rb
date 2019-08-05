module Users::Update
  _, Execute = Common::TxMasterBuilder.new do
    step :validate_params,      with: Common::Operations::Validator.(:update, :user)
    step :get_user,             with: Users::Get.new
    step :validate_password,    with: Users::Update::ValidatePassword.new
    step :update,               with: Users::Update::Update.new
#   map  :build_response,       with: Users::Update::BuildResponse.new
  end.Do
end
