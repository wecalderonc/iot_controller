class ForceCreateSensor2UuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Sensor2, :uuid, force: true
  end

  def down
    drop_constraint :Sensor2, :uuid
  end
end
