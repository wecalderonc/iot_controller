require 'dry/monads'

class Users::Update::ValidatePassword
  include Dry::Monads[:result]

  def call(input)
    if input[:user].valid_password?(input[:current_password])
      Success input.except!(:current_password)
    else
      Failure Errors.general_error("Invalid password", self.class, extra: { code: 400, params: input.to_h })
    end
  end
end
