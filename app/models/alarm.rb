class Alarm
  include Neo4j::ActiveNode
  property :value, type: String
  property :date, type: Date
  property :viewed, type: Boolean

  validates :value, presence: true
  validates :date, presence: true
  validates :viewed, presence: true

  has_one :out, :uplink, type: :BELONGS_TO

end
