module V1
  class ThingsController < ApplicationController
    load_and_authorize_resource
    before_action :set_thing, only: [:show, :update, :destroy]
    # GET /todos
    def index
      @things = Thing.all
      json_response(@things)
    end

    # POST /todos
    def create
      @thing = Thing.create!(thing_params)
      json_response(@thing, :created)
    end

    # GET /things/:id
    def show
      json_response(@thing)
    end

    # PUT /things/:id
    def update
      @thing.update(thing_params)
      head :no_content
    end

    # DELETE /todos/:id
    def destroy
      @thing.destroy
      head :no_content
    end

    private

    def thing_params
      # whitelist params
      params.permit(:name)
    end

    def set_thing
      @thing = Thing.find(params[:id])
    end
  end
end
