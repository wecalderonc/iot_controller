module Users::Authenticate

  BuildPayload = -> user do
    {
      auth_token: JsonWebToken.encode( { user_id: user.id } ),
      email:      user.email
    }
  end

  _, Execute = Common::TxMasterBuilder.new do
    step :find_user,         with: Users::Authenticate::FindUser.new
    step :validate_password, with: Users::Authenticate::ValidatePassword.new
    map  :build_payload,     with: BuildPayload
  end.Do
end
