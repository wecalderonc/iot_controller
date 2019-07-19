class Thing
  include Neo4j::ActiveNode
  property :name, type: String
  property :status, type: String
  property :pac, type: String
  property :company_id, type: String
  property :coordinates

  serialize :coordinates, type: Array

  validates_presence_of :name
  validates_presence_of :status
  validates_presence_of :pac
  validates_presence_of :company_id

  has_many :out, :uplinks, type: :UPLINK_CREATED
  has_one :in, :owner, rel_class: :Owner, model_class: :User
  has_one :in, :operator, rel_class: :Operator, model_class: :User

  VALID_ACTIONS = [:scheduled_cut, :restore_supply, :instant_cut, :restore_supply_with_scheduled_cut]
  VALID_UPDATE_TYPES = [:desired, :reported]

  def last_uplinks(quantity = 1)
    self.uplinks.order(created_at: :desc).limit(quantity)
  end

  def last_accumulators(quantity = 1)
    self.last_uplinks(quantity).map(&:accumulator)
  end
end
