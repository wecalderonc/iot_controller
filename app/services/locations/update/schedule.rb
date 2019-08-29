require 'dry/transaction'

class Locations::Update::Schedule
  include Dry::Transaction

  def call(input, model)
    schedule = input[:thing].locates.send(model)

    Locations::Update::BaseUpdater.new.(input, schedule, model)
  end
end
