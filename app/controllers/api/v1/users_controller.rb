module Api
  module V1
    class UsersController < ApplicationController

      METHODS_WITHOUT_AUTH = [ :create, :request_password_recovery, :change_forgotten_password, :confirm_email ]

      skip_before_action :authorize_request, only: METHODS_WITHOUT_AUTH

      def show
        response = Users::Get.new.(show_params)

        default_show_response(response)
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
          json_response({ errors: user.failure[:message] }, :not_found)
        end
      end

      def update
        options = {
          assign_code: -> { Users::VerificationCode::Execute.new.(params) }
        }

        options.default = -> { Users::Update::Execute.new.(update_params) }

        response = options[params[:subaction]&.to_sym].()

        if response.success?
          json_response(response.success, :ok, UsersSerializer)
        else
          error = response.failure
          render json: error, status: error[:code]
        end
      end

      #NON-RESTFUL
      def request_password_recovery
        response = Users::Password::Recovery.new.(params)

        if response.success?
          json_response(response.success, :ok)
        else
          error = response.failure
          render json: error, status: error[:code]
        end
      end

      def change_forgotten_password
        response = Users::Password::Execute.new.(password_params)

        if response.success?
          json_response(response.success, :ok, UsersSerializer)
        else
          json_response({ errors: response.failure[:message] }, :not_found)
        end
      end

      def confirm_email
        response = Users::Confirm.new.(params[:verification_code])

        if response.success?
          json_response(response.success, :ok)
        else
          error = response.failure
          render json: error, status: error[:code]
        end
      end

      private

      def create_params
        params.permit(
          User::PERMITTED_PARAMS << :country_code
          ).to_h.symbolize_keys
      end

      def update_params
        params.permit(
          User::PERMITTED_PARAMS << [:format, :new_email, :country_code, :current_password]
          ).to_h.symbolize_keys
      end

      def password_params
        params.permit(:email, :format, :password, :current_password, :password_confirmation).to_h.symbolize_keys
      end

      def show_params
        params.permit(:email, :format).to_h.symbolize_keys
      end
    end
  end
end
