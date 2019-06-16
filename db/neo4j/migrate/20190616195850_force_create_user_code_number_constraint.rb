class ForceCreateUserCodeNumberConstraint < Neo4j::Migrations::Base
  def up
    add_constraint :User, :code_number, force: true
  end

  def down
    drop_constraint :User, :code_number
  end
end
