class Thing
  include Neo4j::ActiveNode
  property :name, type: String
  property :title, type: String
end
