module Api
  module V1
    class UsersController < ApplicationController
     skip_before_action :authorize_request

      def show
        options = {
          confirm_email: -> {
            response = Users::Confirmation.verification_code(params)

            if response.success?
              json_response({ message: response.success[:message] }, :ok)
            else
              json_response({ message: response.failure[:message] }, :not_found)
            end
          }
        }
        options.default = -> {
          default_response = Users::Show.find_user(params)

          if default_response.success?
              render json: default_response.success, status: :ok, serializer: UsersSerializer
            else
              json_response({ message: default_response.failure[:message] }, :not_found)
            end
        }

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

      private

      def user_params
        params.permit(User::PERMITTED_PARAMS).to_h.symbolize_keys
      end
    end
  end
end
