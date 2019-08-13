class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def confirmation_email
    @user = params[:user]
    mail(to: @user.email, subject: 'Registration Confirmation')
  end
end
