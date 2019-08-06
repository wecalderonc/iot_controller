module Api
  module V1
    class UsersController < ApplicationController
     skip_before_action :authorize_request

      def show
        options = {
          confirm_email: -> {
            response = Users::Confirmation.verification_code(params)
            render json: response[:json], status: response[:status]
          }
        }
        options.default = -> {
          response = Users::Show.user_show(params)
          render json: response[:json], status: response[:status]
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
