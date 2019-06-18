class ForceCreateAccumulatorUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Accumulator, :uuid, force: true
  end

  def down
    drop_constraint :Accumulator, :uuid
  end
end
