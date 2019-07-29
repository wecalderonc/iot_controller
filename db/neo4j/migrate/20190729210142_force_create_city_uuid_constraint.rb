class ForceCreateCityUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :City, :uuid, force: true
  end

  def down
    drop_constraint :City, :uuid
  end
end
