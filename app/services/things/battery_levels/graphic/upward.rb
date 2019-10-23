require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::Upward
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing]
    battery_levels = input[:batteries].order(:created_at)
    result = search_upward_transition(battery_levels)

    if result.present?
      Success input.merge(upward_transition: result[1])
    else
      Failure Errors.general_error("The thing #{input[:thing].name} does not have an upward transitions between battery levels", self.class)
    end
  end

  private

  def search_upward_transition(battery_levels)
    battery_levels.each_cons(2).detect { |pair| pair[0].value < pair[1].value }
  end
end
