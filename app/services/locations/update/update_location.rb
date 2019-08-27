require 'dry/transaction'

class Locations::Update::UpdateLocation
  include Dry::Transaction

  def call(input)
    # TODO refactor all update files
    location = input[:thing].locates

    if location.update(input[:location])
      Success input
    else
      Failure Errors.general_error(location.errors.messages, self.class)
    end
  end
end
