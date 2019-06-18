class ForceCreateUplinkBDownlinkUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :UplinkBDownlink, :uuid, force: true
  end

  def down
    drop_constraint :UplinkBDownlink, :uuid
  end
end
