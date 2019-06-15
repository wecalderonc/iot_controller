module Api
  module V1
    class AqueductsController < ApplicationController

      def index
        aqueducts = Aqueduct.all
        render json: aqueducts, status: :ok
      end
    end
  end
end
