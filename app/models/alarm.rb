class Alarm
  include Neo4j::ActiveNode
  property :value, type: String

  validates :value, presence: true

  has_one :out, :uplink, type: :BELONGS_TO

end
