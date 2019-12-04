class User
  include Neo4j::ActiveNode

  after_create :assign_verification_code

  property :first_name, type: String
  property :last_name, type: String
  property :email, type: String, constraint: :unique
  property :password, type: String
  property :password_confirmation, type: String
  property :admin, type: Boolean, default: false
  property :phone, type: String
  property :gender, type: String
  property :id_number, type: String
  property :id_type, type: String
  property :user_type, type: String
  property :verificated, type: Boolean, default: false
  property :verification_code, type: String
  #TODO
  #CHANGE UNIQUE FROM CODE_NUMBER TO ID_NUMBER

  MANDATORY_FIELDS = [:first_name, :last_name, :email, :password]
  validates *MANDATORY_FIELDS, presence: true

  PERMITTED_PARAMS = [:first_name, :last_name, :password, :email,
                      :phone, :gender, :id_number, :id_type, :admin,
                      :user_type, :password_confirmation]

  has_many :out, :owns,      rel_class: :Owner,    model_class: :Thing
  has_many :out, :operates,  rel_class: :Operator, model_class: :Thing
  has_many :out, :sees,      rel_class: :Viewer,   model_class: :Thing
  has_many :out, :locates,   rel_class: :UserLocation, model_class: :Location

  has_one :out, :country, type: :ORIGIN_COUNTRY

  VALID_EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  VALID_PASSWORD = /(?-i)(?=^.{8,}$)((?!.*\s)(?=.*[A-Z])(?=.*[a-z]))((?=(.*\d){1,})|(?=(.*\W){1,}))^.*$/i
  GENDERS = [:male, :female]
  ID_TYPES = [:cc, :ce, :natural_nit, :bussines_nit, :foreign_nit, :passport, :civil_register]
  USER_TYPE = [:aqueduct_administrator, :administrator, :aqueduct_client, :aqueduct_operator, :citizen_admin, :citizen_viewer]

  UniqParam = :email

  def valid_password?(password)
    self.password.eql?(password)
  end

  def assign_verification_code
    if self.verification_code.blank?
      self.update(verification_code: SecureRandom.hex(6))
    end
  end

  def email_activate
    self.update(verificated: true, verification_code: nil)
  end
end
