require 'dry/monads'

class Users::Show
  extend Dry::Monads[:result]

  def self.find_user(params)
    user = User.find_by(email: "#{params[:email]}.#{params[:format]}")

    if user
      Success user
    else
      Failure Errors.general_error("User not found", self.class)
    end
  end
end
