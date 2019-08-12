require 'dry/transaction'

class Users::Update::Update
  include Dry::Transaction

  step :update_params
  step :update_country

  def update_params(input)
    user = input[:user]

    if user.update(input)
      Success input
    else
      Failure Errors.general_error(user.errors.messages, self.class)
    end
  end

  def update_country(input)
    if input[:country_code].present?
      Users::UpdateCountry.new.(input)
    else
      Success input
    end
  end
end
