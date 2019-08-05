require 'dry/monads'

module Users::Update
  class ValidatePassword
  include Dry::Monads[:result]

    def call(input)
     if input[:current_password].eql?(input[:user].password)
       Success input.except!(:current_password)
     else
       Failure Errors.general_error("Invalid password", self.class, extra: { code: 400, params: input.to_h })
     end
    end
  end
end
