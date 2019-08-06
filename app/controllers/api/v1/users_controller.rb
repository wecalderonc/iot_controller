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

      def index
        users = User.all
        render json: users, status: :ok, each_serializer: UsersSerializer
      end

      def create
        user = Users::Create::Execute.new.(user_params)

        if user.success?
          render json: user.success, status: :ok, serializer: UsersSerializer
        else
          render json: { errors: user.failure[:message] }, status: :not_found
        end
      end

      private

      def user_params
        params.permit(User::PERMITTED_PARAMS).to_h.symbolize_keys
      end
    end
  end
end
