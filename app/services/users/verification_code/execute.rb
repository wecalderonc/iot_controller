module Users::VerificationCode
  _, Execute = Common::TxMasterBuilder.new do
    step :get_user,                 with: Users::Get.new
    map  :assign_verification_code, with: Users::VerificationCode::Assign.new
    tee  :send_update_confirmation, with: Users::Update::SendMailConfirmation.new
  end.Do
end
