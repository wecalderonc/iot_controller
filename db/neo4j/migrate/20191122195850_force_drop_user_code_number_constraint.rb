class ForceDropUserCodeNumberConstraint < Neo4j::Migrations::Base
  def down
    add_constraint :User, :code_number, force: true
  end

  def up
    drop_constraint :User, :code_number
  end
end
