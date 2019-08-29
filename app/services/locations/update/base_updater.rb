require 'dry/transaction'

class Locations::Update::BaseUpdater
  include Dry::Transaction

  def call(input, object, key)
    if object.update(input[key])
      Success input
    else
      Failure Errors.general_error(object.errors.messages, self.class)
    end
  end
end
