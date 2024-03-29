class BatteryLevel
  include Neo4j::ActiveNode
  property :value, type: String

  validates :value, presence: true

  has_one :out, :uplink, type: :BELONGS_TO

  LEVEL_LABELS = {
    1 => :low,
    2 => :middle_low,
    3 => :middle_high,
    4 => :high,
    5 => :no_available
  }

  LEVEL_LABELS.default = :no_available

  def self.sort_battery_levels(battery_levels, direction)
    battery_levels.order(created_at: direction)
  end
end
