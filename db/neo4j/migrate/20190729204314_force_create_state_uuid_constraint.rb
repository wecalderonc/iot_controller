class ForceCreateStateUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :State, :uuid, force: true
  end

  def down
    drop_constraint :State, :uuid
  end
end
