class ValveState
  include Neo4j::ActiveNode
  property :state, type: String

  validates :state, presence: true

  has_one :in, :thing, type: :VALVE_STATE

  VALVE_STATES = [
    :closed,
    :open,
    :closing_process,
    :opening_process,
    :not_detected
  ]
end
