class Alarm
  include Neo4j::ActiveNode

  property :value, type: String
  property :date, type: Date
  property :viewed, type: Boolean, default: false

  validates :value, presence: true
  validates :date, presence: true

  has_one :out, :uplink, type: :BELONGS_TO
  has_one :out, :alarm_type, type: :TYPE

end
