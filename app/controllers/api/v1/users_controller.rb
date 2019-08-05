module Api
  module V1
    class UsersController < ApplicationController
     skip_before_action :authorize_request

      def show
        options = { confirm_email: -> { return_mail_confirmation(params) } }
        options.default = -> { return_default_show_response(params) }

        options[params[:subaction]&.to_sym].()
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

      def update
        update_response = Users::Update::Execute.new.(update_params)

        if update_response.success?
          json_response(update_response.success)
        else
          json_response({ errors: update_response.failure[:message] })
        end
      end

      private

      def user_params
        params.permit(User::PERMITTED_PARAMS).to_h.symbolize_keys
      end

      def return_mail_confirmation(params)
        response = Users::Confirmation.verification_code(params)
        build_confirm_email_response(response)
      end

      def return_default_show_response(params)
        response = Users::Show.find_user(params)
        default_show_response(response)
      end

      def update_params
        params.permit(:first_name, :last_name, :email, :country, :actual_password, :password, :password_confirmation}).to_h.symbolize_keys
      end
    end
  end
end
