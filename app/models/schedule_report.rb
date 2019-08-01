class ScheduleReport
  include Neo4j::ActiveNode

  property :email, type: String
  property :frequency_day, type: String
  property :frequency_interval, type: String
  property :start_date, type: String

  REQUIRED_FIELDS = [:email, :frequency_day, :frequency_interval, :start_date]

  validates_presence_of REQUIRED_FIELDS

  has_one :out, :location, type: :location
end
