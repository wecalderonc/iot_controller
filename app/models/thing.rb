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

  has_many :out, :uplinks, type: :UPLINK_CREATED

  has_many :in, :owner, type: :OWN, model_class: :User
  has_many :in, :renter, type: :RENT, model_class: :User

  def self.to_csv
    accumulators = ThingsQuery.with_accumulators
    p Things::AccumulatorsReport.(accumulators)
  end
end
