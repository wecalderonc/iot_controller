module Api
  module V1
    class CountriesController < ApplicationController

      skip_before_action :authorize_request

      def index
        countries = Country.all.order(name: :asc)

        render json: countries, status: :ok, each_serializer: CountrySerializer
      end
    end
  end
end
