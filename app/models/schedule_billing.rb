class ScheduleBilling
  include Neo4j::ActiveNode

  property :stratum, type: Integer
  property :basic_charge, type: Float, default: 0
  property :top_limit, type: Float, default: 0
  property :basic_price, type: Float, default: 0
  property :extra_price, type: Float, default: 0
  property :billing_frequency, type: Integer, default: 1
  property :billing_period, type: String
  property :cut_day, type: Integer, default: 1
  property :start_date, type: Date

  REQUIRED_FIELDS = [:stratum, :basic_charge, :top_limit, :basic_price, :extra_price, :billing_frequency, :billing_period, :cut_day, :start_date]
  VALID_PERIODS = [:day, :week, :month, :year]

  validates_presence_of REQUIRED_FIELDS

  has_one :out, :location, type: :location
end
