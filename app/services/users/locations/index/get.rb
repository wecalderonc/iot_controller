require 'dry/transaction/operation'

class Users::Locations::Index::Get
  include Dry::Transaction::Operation

  def call(input)
    user = input[:user]
    locations = user.locates

    if locations.present?
      Success locations.to_a
    else
      Failure Errors.general_error("The user #{input[:user].email} does not have locations", self.class)
    end
  end
end
