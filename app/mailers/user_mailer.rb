class UserMailer < ApplicationMailer
  default from: 'waico@waico.com.co'

  def confirmation_email
    base_email('Confirmación de registro en WAICO')
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
