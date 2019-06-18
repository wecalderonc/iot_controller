class ForceCreateValvePositionUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :ValvePosition, :uuid, force: true
  end

  def down
    drop_constraint :ValvePosition, :uuid
  end
end
