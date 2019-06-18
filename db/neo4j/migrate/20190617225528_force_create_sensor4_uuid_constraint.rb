class ForceCreateSensor4UuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Sensor4, :uuid, force: true
  end

  def down
    drop_constraint :Sensor4, :uuid
  end
end
