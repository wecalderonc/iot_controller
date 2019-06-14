require 'dry/monads/try'
class JsonWebToken
  extend Dry::Monads::Try::Mixin

  ERRORS = [JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError]
  JWT_SECRET = Rails.application.secrets.secret_key_base
  EXP = ENV["EXPIRATION_TIME"].to_i.hours.from_now

  BuildHash = -> body { HashWithIndifferentAccess.new body }

  def self.encode(payload)
    payload[:exp] = EXP.to_i
    JWT.encode(payload, JWT_SECRET)
  end

  def self.decode(token)
    Try(ERRORS) { JWT.decode(token, JWT_SECRET) }.fmap { |user| BuildHash.(user[0]) }
  end
end
