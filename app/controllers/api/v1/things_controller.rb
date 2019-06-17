module Api
  module V1
    class ThingsController < ApplicationController

      def index
        things = Thing.all
        render json: things, status: :ok
      end
    end
  end
end
