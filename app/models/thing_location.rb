class ThingLocation
  include Neo4j::ActiveRel

  from_class :Thing
  to_class   :Location
  type :thing_location
end
