class ThingLocation
  include Neo4j::ActiveRel

  from_class :Location
  to_class   :Thing
  type :thing_location
end
