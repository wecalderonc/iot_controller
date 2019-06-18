class ForceCreateBatteryLevelUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :BatteryLevel, :uuid, force: true
  end

  def down
    drop_constraint :BatteryLevel, :uuid
  end
end
