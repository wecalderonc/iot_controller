module Api
  module V1
    class AccumulatorsReportController < ApplicationController
    include ActionController::MimeResponds
 
      def index
        data = Thing.all.to_csv
        respond_to do |format|
          format.html
          format.csv { send_data data, filename: "users-#{Date.today}.csv" }
        end
      end
    end
  end
end
