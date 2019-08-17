class ScheduleReport
  include Neo4j::ActiveNode

  property :email, type: String
  property :frequency_day, type: String, default: 1
  property :frequency_interval, type: String, default: 'month'
  property :start_date, type: String

  REQUIRED_FIELDS = [:email, :frequency_day, :frequency_interval, :start_date]
  VALID_INTERVALS = [:week, :month]

  validates_presence_of REQUIRED_FIELDS

  has_one :out, :location, type: :location
end
