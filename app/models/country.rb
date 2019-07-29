class Country
  include Neo4j::ActiveNode

  property :name, type: String
  property :code_iso, type: String

  validates_presence_of :name
  validates_presence_of :code_iso

  has_many :in, :states, type: :states
end
