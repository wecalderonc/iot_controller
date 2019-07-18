class Accumulator
  include Neo4j::ActiveNode
  property :value, type: String

  validates :value, presence: true

  has_one :out, :uplink, type: :BELONGS_TO
  has_one :out, :price, type: :BELONGS_TO
end
