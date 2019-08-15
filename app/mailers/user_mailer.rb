class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def confirmation_email
    base_email('Registration Confirmation')
  end

  def update_confirmation
    base_email('Update Confirmation')
  end

  def base_email(subject)
    @user = params[:user]
    mail(to: @user.email, subject: subject)
  end

  def recovery_email
    base_email('Password Recovery')
  end
end
