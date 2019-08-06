module Api
  module V1
    class UsersController < ApplicationController
     skip_before_action :authorize_request

      def show
        options = {
          confirm_email: -> { confirm_email(params) }
          recover_password: -> { recover_password(params) }
        }
        options.default = -> { user_show(params) }

        options[params[:subaction]&.to_sym].()
      end

      def index
        users = User.all
        render json: users, status: :ok, each_serializer: UsersSerializer
      end

      def create
        @user = Users::Create::Execute.new.(user_params)

        if @user.success?
          UserMailer.with(user: @user.success).welcome_email.deliver_now
          render json: @user.success, status: :ok, serializer: UsersSerializer
        else
          render json: { errors: @user.failure[:message] }, status: :not_found
        end
      end

      private

      def user_params
        params.permit(User::PERMITTED_PARAMS).to_h.symbolize_keys
      end

      def user_show(params)
        user = User.find_by(email: "#{params["email"]}.#{params[:format]}")

        if user
          render json: { id: user.id, email: user.email, name: user.first_name }, status: :ok
        else
          render json: { errors: "user not found" }, status: :not_found
        end
      end

      def confirm_email(params)
        user = User.find_by(verification_code: params[:id])

        if user
          user.email_activate
          render json: { message: "Email Confirmed! Thanks!" }, status: :ok
        else
          render json: { errors: @user.failure[:message] }, status: :not_found
        end
      end
    end
  end
end
