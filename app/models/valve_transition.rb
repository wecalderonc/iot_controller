class ValveTransition
  include Neo4j::ActiveNode
  property :real_state, type: String, default: :not_detected
  property :showed_state, type: String, default: :not_detected

  has_one :in, :thing, type: :VALVE_TRANSITION

  SHOWED_STATES = [
    :closed,
    :open,
    :closing,
    :opening,
    :not_detected
  ]

  REAL_STATES = [
    :awaiting_downlink,
    :awaiting_open,
    :awaiting_closed,
    :open,
    :closed,
    :not_detected
  ]


  validates :real_state, presence: true, inclusion: { in: REAL_STATES.map(&:to_s) }
  validates :showed_state, presence: true, inclusion: { in: SHOWED_STATES.map(&:to_s) }
end
