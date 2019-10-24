require 'dry/transaction/operation'

class Things::BatteryLevels::Graphic::Upward
  include Dry::Transaction::Operation

  def call(input)
    thing = input[:thing]
    battery_levels = input[:batteries].order(:created_at)
    result = search_upward_transition(battery_levels)

    input.merge(upward_transition: result)
  end

  private

  def search_upward_transition(battery_levels)
    pair = battery_levels.each_cons(2).detect { |pair| pair[0].value < pair[1].value }
    pair.present? ? pair[1] : {}
  end
end
