class ForceCreateTimeUplinkUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :TimeUplink, :uuid, force: true
  end

  def down
    drop_constraint :TimeUplink, :uuid
  end
end
