class UserLocation
  include Neo4j::ActiveRel

  from_class :User
  to_class   :Location
  type :user_location
end
