class Alarm
  include Neo4j::ActiveNode

  property :value, type: String
  property :viewed_date, type: Date
  property :viewed, type: Boolean, default: false

  validates :value, presence: true

  has_one :out, :uplink, type: :BELONGS_TO
  has_one :out, :alarm_type, type: :TYPE

end
