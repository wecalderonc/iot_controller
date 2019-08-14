require 'dry/transaction/operation'

class Users::ParseEmail
  include Dry::Transaction::Operation

  def call(input)
    if input[:new_email].present?
      input[:email] = input.delete(:new_email)

      input.except!(:format)
    else
      input.except!(:email, :format)
    end
  end
end
