require 'dry/transaction/operation'

class Users::Get
  include Dry::Transaction::Operation

  def call(input)
    puts "input -> #{input.inspect}"
    puts User.all.inspect
    user = User.find_by(id: input[:id])

    if user.present?
      Success input.merge(user: user)
    else
      Failure Errors.general_error("The user #{input[:first_name]} does not exist", self.class)
    end
  end
end
