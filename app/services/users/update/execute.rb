module Users::Update
  _, Execute = Common::TxMasterBuilder.new do
    step :validate_params,          with: Common::Operations::Validator.(:update, :user)
    step :get_user,                 with: Users::Get.new
    step :validate_password,        with: Users::Update::ValidatePassword.new
    map  :parse_email,              with: Users::ParseEmail.new
    step :update,                   with: Users::Update::Update.new
    tee  :send_update_confirmation, with: Users::Update::SendMailConfirmation.new
  end.Do
end
