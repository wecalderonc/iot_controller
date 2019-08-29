require 'dry/transaction'

class Locations::Update::UpdateLocation
  include Dry::Transaction

  def call(input)
    location = input[:thing].locates

    Locations::Update::BaseUpdater.new.(input, location, :location)
  end
end
