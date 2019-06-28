module Api
  module V1
    class ThingsController < ApplicationController
      def show
        thing = Thing.find_by(id: params[:id])
        if thing.present?
          json_response(thing)
        else
          json_response({ errors: "thing not found" }, :not_found)
        end
      end
    end
  end
end
