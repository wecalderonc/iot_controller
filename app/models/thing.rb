class Thing
  include Neo4j::ActiveNode
  property :name, type: String
  property :status, type: String
  property :pac, type: String
  property :company_id, type: String

  validates_presence_of :name
  validates_presence_of :status
  validates_presence_of :pac
  validates_presence_of :company_id
end
