class Price
  include Neo4j::ActiveNode
  #TODO convert to sym
  property :unit,     type: String
  property :value,    type: Float
  property :date,     type: Date
  #TODO convert to sym
  property :currency, type: String

  validates :unit,     presence: true
  validates :value,    presence: true
  validates :date,     presence: true
  validates :currency, presence: true
end
