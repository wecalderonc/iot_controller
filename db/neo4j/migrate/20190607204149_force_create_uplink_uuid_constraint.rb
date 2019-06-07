class ForceCreateUplinkUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Uplink, :uuid, force: true
  end

  def down
    drop_constraint :Uplink, :uuid
  end
end
