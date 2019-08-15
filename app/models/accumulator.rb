class Accumulator
  include Neo4j::ActiveNode
  property :value, type: String

  validates :value, presence: true

  has_one :out, :uplink, type: :BELONGS_TO
  has_many :out, :prices, type: :BELONGS_TO

  def my_units
    self.uplink.thing.units
  end

  def int_value
    Base::Maths.hexa_to_int self.value
  end
end
