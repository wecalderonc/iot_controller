class ForceCreateScheduleReportUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :ScheduleReport, :uuid, force: true
  end

  def down
    drop_constraint :ScheduleReport, :uuid
  end
end
