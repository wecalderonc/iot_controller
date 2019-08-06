class Users::Show
  def self.user_show(params)
    user = User.find_by(email: "#{params["email"]}.#{params[:format]}")

    if user
      { json: { id: user.id, email: user.email, name: user.first_name }, status: :ok }
    else
      { json: { errors: "user not found" }, status: :not_found }
    end
  end
end
