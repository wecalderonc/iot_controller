class Operator
  include Neo4j::ActiveRel

  from_class :User
  to_class   :Thing
  type :OPERATE
end
