require 'dry/transaction/operation'

class Users::Update::SendMailConfirmation
  include Dry::Transaction::Operation

  def call(input)
    UserMailer.with(user: input).update_confirmation.deliver_now
  end
end
