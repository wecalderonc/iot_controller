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
        user = Users::Create::Execute.new.(create_params)

        if user.success?
          json_response(user.success, :ok, UsersSerializer)
        else
          render json: { errors: @user.failure[:message] }, status: :not_found
        en
      end

      def update
        update_response = Users::Update::Execute.new.(update_params)

        if update_response.success?
          json_response(update_response.success, :ok, UsersSerializer)
        else
          json_response({ errors: update_response.failure[:message] }, :not_found)
        end
      end

      private

      def create_params
        params.permit(
          User::PERMITTED_PARAMS << :country_code
        ).to_h.symbolize_keys
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
        params.permit(
          User::PERMITTED_PARAMS << [:format, :new_email, :country_code, :current_password]
        ).to_h.symbolize_keys
      end
    end
  end
end
