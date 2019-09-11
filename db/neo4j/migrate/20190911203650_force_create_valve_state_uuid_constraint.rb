class ForceCreateValveStateUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :ValveState, :uuid, force: true
  end

  def down
    drop_constraint :ValveState, :uuid
  end
end
