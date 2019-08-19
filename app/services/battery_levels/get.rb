require 'dry/transaction/operation'

class BatteryLevels::Get
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing]
    batteries = thing.uplinks.batteryLevel

    if batteries.present?
      Success input.merge(batteries: batteries)
    else
      Failure Errors.general_error("The thing #{input[:thing_name]} does not have battery level history", self.class)
    end
  end
end
