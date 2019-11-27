require 'dry/transaction'

class Locations::Create::ValidateUser
  include Dry::Transaction

  def call(input)
    if input[:thing].owner.present?
      Failure Errors.general_error("Thing already taken by another user", self.class)
    else
      Success input
    end
  end
end
