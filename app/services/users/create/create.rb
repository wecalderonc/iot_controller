module Users::Create
  _, Create = Common::TxMasterBuilder.new do
    step :create_user,     with: Users::Create::User.new
    step :assign_country,  with: Users::UpdateCountry.new
  end.Do
end
