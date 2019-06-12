class Thing
  include Neo4j::ActiveNode
  property :name, type: String

  validates_presence_of :name
end
