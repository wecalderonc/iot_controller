require 'dry/transaction/operation'

class Things::BatteryLevels::Classification
  include Dry::Transaction::Operation

  def call(input)
    battery_levels = input[:batteries]

    result = add_level_label(battery_levels)
  end

  private

  def add_level_label(battery_levels)
    battery_levels.inject([]) do |array, battery_level|
      last_digit = get_last_digit(battery_level)
      level = get_level(last_digit)
      array << battery_level.attributes.merge(level_label: level, digit: last_digit)
    end
  end

  def get_last_digit(battery_level)
    battery_level.value[-1].to_i
  end

  def get_level(last_digit)
    if BatteryLevel::LEVEL_LABELS.include?(last_digit)
      BatteryLevel::LEVEL_LABELS[last_digit]
    else
      :does_not_apply
    end
  end
end

