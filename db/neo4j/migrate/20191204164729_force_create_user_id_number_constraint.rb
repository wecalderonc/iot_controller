class ForceCreateUserIdNumberConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :User, :id_number, force: true
  end

  def down
    drop_constraint :User, :id_number
  end
end
