class ScheduleBilling
  include Neo4j::ActiveNode

  property :stratum, type: Integer
  property :basic_charge, type: Float
  property :top_limit, type: Float
  property :basic_price, type: Float
  property :extra_price, type: Float
  property :billing_frequency, type: Integer
  property :billing_period, type: String
  property :cut_day, type: Integer
  property :start_date, type: String

  REQUIRED_FIELDS = [:stratum, :basic_charge, :top_limit, :basic_price, :extra_price, :billing_frequency, :billing_period, :cut_day, :start_date]

  validates_presence_of REQUIRED_FIELDS

  has_one :out, :location, type: :location
end
