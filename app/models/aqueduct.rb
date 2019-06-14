class Aqueduct
  include Neo4j::ActiveNode
  property :name, type: String

  validates_presence_of :name

  has_many :out, :support_workers, type: :SUPPORT_WORKERS, model_class: :User
end
