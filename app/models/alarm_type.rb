class AlarmType
  include Neo4j::ActiveNode

  property :name, type: String
  property :value, type: Integer
  property :type, type: String

  validates :value, presence: true
  validates :name, presence: true
  validates :type, presence: true
end
