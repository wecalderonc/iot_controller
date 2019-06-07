class ForceCreateThingUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Thing, :uuid, force: true
  end

  def down
    drop_constraint :Thing, :uuid
  end
end
