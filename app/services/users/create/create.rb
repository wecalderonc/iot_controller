require 'dry/transaction/operation'

class Users::Create::Create
  include Dry::Transaction::Operation

  def call(input)
    p user = User.new(input)
    p "!!!!!! INICIO"
    p hola = user.save
    p hola.inspect
    p "!!!!!!FINALLL"

    if hola
      Success input.merge(user: user)
    else
      Failure Errors.general_error("Problems with saving", self.class)
    end
  end
end
