class ForceCreateValveTransitionUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :ValveTransition, :uuid, force: true
  end

  def down
    drop_constraint :ValveTransition, :uuid
  end
end
