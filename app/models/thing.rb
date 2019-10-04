class Thing
  include Neo4j::ActiveNode
  property :name, type: String
  property :status, type: String
  property :pac, type: String
  property :company_id, type: String
  property :latitude, type: Float
  property :longitude, type: Float
  property :units

  serialize :units

  VALID_ACTIONS = [:scheduled_cut, :restore_supply, :instant_cut, :restore_supply_with_scheduled_cut]
  VALID_UPDATE_TYPES = [:desired, :reported]
  REQUIRED_FIELDS = [:name, :status, :pac, :company_id, :longitude, :latitude]


  validates_presence_of REQUIRED_FIELDS
  validates_uniqueness_of :name, case_sensitive:false

  validate :check_units

  has_many :out, :uplinks,      type: :UPLINK_CREATED
  has_one  :out, :valve_transition,  type: :VALVE_TRANSITION

  has_many :in, :owner,    rel_class: :Owner,    model_class: :User
  has_many :in, :operator, rel_class: :Operator, model_class: :User
  has_many :in, :viewer,   rel_class: :Viewer,   model_class: :User

  has_one :out, :locates, rel_class: :ThingLocation, model_class: :Location

  def last_uplinks(quantity = 1)
    self.uplinks.order(created_at: :desc).limit(quantity)
  end

  def last_accumulators(quantity = 1)
    self.last_uplinks(quantity).map(&:accumulator)
  end

  def has_new_alarms?
    self.uplinks.alarm.map(&:viewed).any?(true)
  end

  private

  #TODO: Fix this in the next version.
  def check_units
    if units.present?
      if not units.is_a?(Hash)
        errors.add(:units, "Units must be a Hash")
      elsif units.values.any?(0)
        errors.add(:units_values, "Units can not be zero")
      end
    end
  end
end
