class ForceCreateAqueductUuidConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :Aqueduct, :uuid, force: true
  end

  def down
    drop_constraint :Aqueduct, :uuid
  end
end
