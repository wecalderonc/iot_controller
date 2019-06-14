class CreateAqueduct < Neo4j::Migrations::Base
  def up
    add_constraint :Aqueduct, :uuid
  end

  def down
    drop_constraint :Aqueduct, :uuid
  end
end
