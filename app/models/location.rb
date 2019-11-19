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

  has_one :in, :thing,  model_class: :Thing, origin: :Thing

  has_many :in, :users, rel_class: :UserLocation, model_class: :User
end
