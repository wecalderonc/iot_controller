class Location
  include Neo4j::ActiveNode
  property :name, type: String
  property :address, type: String
  property :latitude, type: Float
  property :longitude, type: Float

  REQUIRED_FIELDS = [:name, :address]

  validates_presence_of REQUIRED_FIELDS

  has_one :out, :city, type: :city
  has_one :out, :schedule_report, type: :schedule_report
  has_one :out, :schedule_billing, type: :schedule_report
end
