module Api
  module V1
    class AlarmsReportController < ApplicationController
    include ActionController::MimeResponds

      def index
        alarms = ThingsQuery.new.sort_alarms

        build_response(alarms, :Alarms)
      end

      def show
        show_handler({ params: params, model: :Alarms })
      end
    end
  end
end
