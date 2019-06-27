module Api
  module V1
    class UsersController < ApplicationController

      def show
        user = User.find_by(email: "#{params["email"]}.#{params[:format]}")
        if user
          render json: { id: user.id, email: user.email, name: user.first_name }, status: :ok
        else
          render json: { errors: "user not found" }, status: :not_found
        end
      end

    end
  end
end
