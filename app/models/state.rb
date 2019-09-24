class State
  include Neo4j::ActiveNode

  property :name, type: String
  property :code_iso, type: String

  validates_presence_of :name
  validates_presence_of :code_iso

  has_one :in, :country, type: :states
  has_many :in, :cities, type: :cities
end
