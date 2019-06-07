class CreateUplink < Neo4j::Migrations::Base
  def up
    add_constraint :Uplink, :uuid
  end

  def down
    drop_constraint :Uplink, :uuid
  end
end
