class Aqueduct 
  include Neo4j::ActiveNode
  property :name, type: String
  property :email, type: String
  property :phone, type: String

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true

  has_many :out, :support_workers, type: :SUPPORT_WORKERS, model_class: :User
end
