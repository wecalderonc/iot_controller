module Api
  module V1
    class UsersController < ApplicationController
     skip_before_action :authorize_request

      def show
        options = { confirm_email: -> { return_mail_confirmation(params) },
                    request_password_recovery: -> { return_request_password_recovery(params) }
                  }
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
          render json: { errors: user.failure[:message] }, status: :not_found
        end
      end

      def update
        options = { forgot_password: -> { return_change_password } }
        options.default = -> { return_default_update_response(update_params) }

        options[params[:subaction]&.to_sym].()
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

      def return_default_update_response(update_params)
        update_response = Users::Update::Execute.new.(update_params)

        if update_response.success?
          json_response(update_response.success, :ok, UsersSerializer)
        else
          json_response({ errors: update_response.failure[:message] }, :not_found)
        end
      end

      def return_change_password
        update_password_response = Users::Password::Execute.new.(password_params)

        if update_password_response.success?
          render json: update_password_response.success, status: :ok, serializer: UsersSerializer
        else
          json_response({ errors: update_password_response.failure[:message] }, :not_found)
        end
      end

      def return_request_password_recovery(params)
        response = Users::Password::Recovery.new.(params)

        if response.success
          render json: { message: response.success[:message] }, status: :ok
        else
          render json: response.failure, status: :not_found
        end
      end

      def update_params
        params.permit(
          User::PERMITTED_PARAMS << [:format, :new_email, :country_code, :current_password]
        ).to_h.symbolize_keys
      end

      def password_params
        params.permit(:email, :format, :password, :current_password, :password_confirmation).to_h.symbolize_keys
      end
    end
  end
end
