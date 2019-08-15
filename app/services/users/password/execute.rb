module Users::Password
  _, Execute = Common::TxMasterBuilder.new do
    step :validation,                 with: Common::Operations::Validator.(:recover_password, :user)
    step :old_password_verification,  with: Users::Password::Comparison.new
    step :update_new_password,        with: Users::Password::Update.new
  end.Do
end


