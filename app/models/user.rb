class User
  include Neo4j::ActiveNode
  property :name, type: String
  property :password, type: String
  property :password_confirmation, type: String
  property :email, type: String
  property :admin, type: Boolean

  validates :password, presence: true
  validates :email, presence: true

  has_one :in, :support_workers, type: :SUPPORT_WORKERS, model_class: :Aqueduct


  VALID_EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  UniqParam = :email

  def valid_password?(password)
    self.password.eql?(password)
  end
end
