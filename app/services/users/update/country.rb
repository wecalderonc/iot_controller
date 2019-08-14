require 'dry/transaction'

class Users::Update::Country
  include Dry::Transaction

  def call(input)
    if input[:country_code].present?
      Users::UpdateCountry.new.(input)
    else
      Success input[:user]
    end
  end
end
