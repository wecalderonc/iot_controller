class Aqueduct
  include Neo4j::ActiveNode
  property :name, type: String
  property :email, type: String
  property :phone, type: String

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :phone

  has_many :out, :support_workers, type: :SUPPORT_WORKERS, model_class: :User
end
