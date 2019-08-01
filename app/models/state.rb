class State
  include Neo4j::ActiveNode

  property :name, type: String
  property :code_iso, type: String

  validates_presence_of :name
  validates_presence_of :code_iso

  has_one :out, :country, type: :country
  has_many :in, :cities, type: :cities
end
