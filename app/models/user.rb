class User
  include Neo4j::ActiveNode
  property :name, type: String
  property :password, type: String
  property :password_confirmation, type: String
  property :email, type: String

  validates :password, presence: true
  validates :email, presence: true

  def valid_password?(password)
    self.password.eql?(password)
  end
end
