class ForceCreateScheduleBillingUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :ScheduleBilling, :uuid, force: true
  end

  def down
    drop_constraint :ScheduleBilling, :uuid
  end
end
