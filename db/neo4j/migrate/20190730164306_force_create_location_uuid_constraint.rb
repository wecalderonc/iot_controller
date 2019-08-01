class ForceCreateLocationUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Location, :uuid, force: true
  end

  def down
    drop_constraint :Location, :uuid
  end
end
