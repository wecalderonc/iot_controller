class JsonWebToken

  JWT_SECRET = Rails.application.secrets.secret_key_base
  EXP = 24.hours.from_now

  def self.encode(payload)
    payload[:exp] = EXP.to_i
    JWT.encode(payload, JWT_SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, JWT_SECRET)[0]
    HashWithIndifferentAccess.new body
    rescue
      nil
  end
end
