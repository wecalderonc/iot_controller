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

  VALID_ACTIONS = [:scheduled_cut, :restore_supply, :instant_cut, :restore_supply_with_scheduled_cut]
  VALID_UPDATE_TYPES = [:desired, :reported]

  def last_accumulators(quantity = 1)
    if quantity.eql?(1)
      last_uplink.present? ? last_uplink.accumulator : nil
    else
      self.uplinks.accumulator.limit(quantity)
    end
  end

  def last_uplink
    self.uplinks.order(created_at: :asc).last
  end
end
