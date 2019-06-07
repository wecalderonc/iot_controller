class CreateThing < Neo4j::Migrations::Base
  def up
    add_constraint :Thing, :uuid
  end

  def down
    drop_constraint :Thing, :uuid
  end
end
