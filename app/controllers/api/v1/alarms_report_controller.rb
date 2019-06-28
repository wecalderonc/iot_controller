module Api
  module V1
    class AlarmsReportController < ApplicationController
    include ActionController::MimeResponds

      def index
        alarms = ThingsQuery.new.sort_alarms

        build_response(alarms, :alarms)
      end

      def show
        show_handler({ params: params, model: :alarms })
      end
    end
  end
end
