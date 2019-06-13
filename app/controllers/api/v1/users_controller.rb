module Api
  module V1
    class UsersController < ApplicationController

      # GET /api/v1/users
      def index
        user = User.find_by(email: params["email"])
        if user
          render json: { id: user.id, email: user.email, name: user.name }, status: 200
        else
          render json: { errors: "user not found" }, status: 404
        end
      end
    end
  end
end
