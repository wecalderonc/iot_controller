class BatteryLevel
  include Neo4j::ActiveNode
  property :value, type: String

  validates :value, presence: true

  has_one :out, :uplink, type: :BELONGS_TO

  LEVEL_LABELS = {
    "1": "low",
    "2": "middle-low",
    "3": "middle-high",
    "4": "high",
    "5": "no_available"
  }
end
