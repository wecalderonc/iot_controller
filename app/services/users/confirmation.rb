class Users::Confirmation
  def self.verification_code(params)
    user = User.find_by(verification_code: params[:token])

    if user
      user.email_activate
      { json: { message: "Email Confirmed! Thanks!" }, status: :ok }
    else
      { json: { errors:  "Token expired or incorrect - User not found" }, status: :not_found }
    end
  end
end
