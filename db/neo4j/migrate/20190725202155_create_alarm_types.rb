class CreateAlarmTypes < Neo4j::Migrations::Base
  def up
    add_constraint :AlarmType, :uuid, force: true
  end

  def down
    drop_constraint :AlarmType, :uuid
  end
end
