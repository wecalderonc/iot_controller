class ForceCreateSensor3UuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Sensor3, :uuid, force: true
  end

  def down
    drop_constraint :Sensor3, :uuid
  end
end
