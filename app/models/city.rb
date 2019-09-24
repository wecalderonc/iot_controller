class City
  include Neo4j::ActiveNode

  property :name, type: String

  validates_presence_of :name

  has_one :out, :state, type: :cities
end
