class Owner
  include Neo4j::ActiveRel

  from_class :User
  to_class   :Thing
  type :OWN
  # `type` can be specified, but it is assumed from the model name
  # In this case, without `type`, 'ENROLLED_IN' would be assumed
  # If you wanted to specify something else:
  # type 'ENROLLED'

  # property :since, type: Integer

  # validates_presence_of :since
end
