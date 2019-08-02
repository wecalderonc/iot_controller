class User
  include Neo4j::ActiveNode

  property :first_name, type: String
  property :last_name, type: String
  property :email, type: String, constraint: :unique
  property :password, type: String
  property :password_confirmation, type: String
  property :admin, type: Boolean
  property :phone, type: String
  property :gender, type: String
  property :id_number, type: String
  property :id_type, type: String
  property :code_number, type: String, constraint: :unique
  property :user_type, type: String

  #TODO
  #AGREGAR UNIQUE A ID_NUMBER

  MANDATORY_FIELDS = [:first_name, :last_name, :email, :password, :phone, :gender, :id_number, :id_type]
  validates *MANDATORY_FIELDS, presence: true

  has_many :out, :owns,      rel_class: :Owner,    model_class: :Thing
  has_many :out, :operates,  rel_class: :Operator, model_class: :Thing
  has_many :out, :sees,      rel_class: :Viewer,   model_class: :Thing

  VALID_EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  GENDERS = [:male, :female]
  ID_TYPES = [:cc, :ce, :natural_nit, :bussines_nit, :foreign_nit, :passport, :civil_register]
  USER_TYPE = [:aqueduct_administrator, :administrator, :aqueduct_client, :aqueduct_operator, :citizen_admin, :citizen_viewer]

  UniqParam = :email

  def valid_password?(password)
    self.password.eql?(password)
  end
end
