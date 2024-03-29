require 'dry/transaction/operation'

class Users::SendMailConfirmation
  include Dry::Transaction::Operation

  def call(input)
    UserMailer.with(user: input).confirmation_email.deliver_now
  end
end
