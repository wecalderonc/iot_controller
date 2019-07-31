class UserLocation
  include Neo4j::ActiveRel

  from_class :Location
  to_class   :User
  type :user_location
end
