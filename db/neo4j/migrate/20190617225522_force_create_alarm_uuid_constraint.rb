class ForceCreateAlarmUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Alarm, :uuid, force: true
  end

  def down
    drop_constraint :Alarm, :uuid
  end
end
