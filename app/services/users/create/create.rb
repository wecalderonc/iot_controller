require 'dry/transaction'

class Users::Create::Create
  include Dry::Transaction

  step :create_user
  step :assign_country

  def create_user(input)
    user = User.new(input.except(:country_code))

    if user.save
      Success input.merge(user: user)
    else
      Failure Errors.general_error("Errors in saving process", self.class)
    end
  end

  def assign_country(input)
    Users::UpdateCountry.new.(input)
  end
end
