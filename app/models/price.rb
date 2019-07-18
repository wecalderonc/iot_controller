class Price
  include Neo4j::ActiveNode
  property :unit,     type: String
  property :price,    type: Float
  property :date,     type: Date
  property :currency, type: String

  validates :unit,     presence: true
  validates :price,    presence: true
  validates :date,     presence: true
  validates :currency, presence: true
end
