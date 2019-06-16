class ForceCreateUserEmailConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :User, :email, force: true
  end

  def down
    drop_constraint :User, :email
  end
end
