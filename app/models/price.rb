class Price
  include Neo4j::ActiveNode

  CURRENCIES = Money::Currency.all.map(&:iso_code).freeze

  property :unit,     type: String
  property :value,    type: Float
  property :date,     type: Date
  property :currency, type: String

  validates :unit,     presence: true
  validates :value,    presence: true
  validates :date,     presence: true
  validates :currency, presence: true

  validates :value, numericality: { greater_than: 0 }

  validates :currency, inclusion: { in: CURRENCIES }

  def self.by_unit(unit)
    self.where(unit: unit).order(:desc).last
  end
end
