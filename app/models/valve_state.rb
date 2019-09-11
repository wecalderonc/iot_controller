class ValveState
  include Neo4j::ActiveNode
  property :state, type: String

  has_one :in, :thing, type: :VALVE_STATE

  VALVE_STATES = [
    :closed,
    :open,
    :closing_process,
    :opening_process,
    :not_detected
  ]

  validates :state, presence: true, inclusion: { in: VALVE_STATES.map(&:to_s) }
end
