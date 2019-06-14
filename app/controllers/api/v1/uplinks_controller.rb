module Api
  module V1
    class UplinksController < ApplicationController
      def index
        @uplinks = Uplink.all
        json_response(@uplinks)
      end
    end
  end
end
