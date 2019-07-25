class ForceCreatePriceUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Price, :uuid, force: true
  end

  def down
    drop_constraint :Price, :uuid
  end
end
