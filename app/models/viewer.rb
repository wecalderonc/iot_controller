class Viewer
  include Neo4j::ActiveRel

  from_class :User
  to_class   :Thing
  type :SEE
end
