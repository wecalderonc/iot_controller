require 'dry/transaction'

class Locations::ValidateUser
  include Dry::Transaction

  def call(input)
    owner = input[:thing].owner[0]

    if owner.present? && owner != input[:user]
      Failure Errors.general_error("Thing already taken by another user", self.class)
    else
      Success input
    end
  end
end
