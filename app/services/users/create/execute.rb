module Users::Create
  _, Execute = Common::TxMasterBuilder.new do
    map  :parse_input,            with: Users::ParseInput.new
    step :validation,             with: Common::Operations::Validator.(:create, :user)
    step :create,                 with: Users::Create::Create.new
    tee  :send_confirmation_mail, with: Users::SendMailConfirmation.new
  end.Do
end


