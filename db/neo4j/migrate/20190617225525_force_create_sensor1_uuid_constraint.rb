class ForceCreateSensor1UuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Sensor1, :uuid, force: true
  end

  def down
    drop_constraint :Sensor1, :uuid
  end
end
