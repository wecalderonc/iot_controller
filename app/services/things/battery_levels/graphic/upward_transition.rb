require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::UpwardTransition
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing]
    battery_levels = BatteryLevel.sort_battery_levels(input[:batteries], :desc)
    upward_transition = search_upward_transition(battery_levels)

    input.merge(upward_transition: upward_transition)
  end

  private

  def search_upward_transition(battery_levels)
    result = battery_levels.each_cons(2).detect { |pair| pair[0].value > pair[1].value }
    result.present? ? result[1] : nil
  end
end
