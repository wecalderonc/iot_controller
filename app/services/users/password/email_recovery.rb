class Users::Password::EmailRecovery
  def self.send_mail(params)
    user = User.find_by(email: "#{params["email"]}.#{params[:format]}")

    if user
      UserMailer.with(user: user).recovery_email.deliver_now
      { json: { message: "Email Sended! Go to your inbox!" }, status: :ok }
    else
      { json: { errors:  "User not found" }, status: :not_found }
    end
  end
end
