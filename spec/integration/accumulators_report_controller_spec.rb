require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Accumulators Report API", :type => :request do
  path "/api/v1/accumulators_report" do
    get 'Retrieves all accumulators related with all things' do
      tags 'Alarms Report'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: "date[start_date]", :in => :query, :type => :string
      parameter name: "date[end_date]", :in => :query, :type => :string

      response '200', 'accumulators founded' do
        let(:start_date)         { (Time.now - 2.days).to_time.to_i.to_s }
        let(:end_date)           { (Time.now - 2.days).to_time.to_i.to_s }
        let(:'date[start_date]') { start_date }
        let(:'date[end_date]')   { end_date }
        let!(:uplink)            { create(:uplink, time: end_date) }
        let!(:accumulator1)      { create(:accumulator, uplink: uplink) }
        let!(:accumulator2)      { create(:accumulator) }
        let(:user)               { create(:user) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
        items: {
          type: :object,
          properties: {
            thing_id: { type: :string },
            thing_name: { type: :string },
            accumulators: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  date: { type: :string },
                  value: { type: :string },
                  consumption_delta: { type: :integer },
                  accumulated_delta: { type: :integer }
                }
              }
            }
          },
          required: ['thing_id', 'thing_name', 'accumulators']
        }

        run_test!
      end

      response '404', 'Results not found' do
        let(:'date[start_date]') { (Time.now - 2.days).to_time.to_i.to_s }
        let(:'date[end_date]')   { Time.now.to_time.to_i.to_s }
        let(:user)               { create(:user) }
        let(:Authorization)      { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          properties: {
            errors: { type: :string },
            code: { type: :integer }
          },
          required: [ 'errors', 'code' ]

        run_test!
      end
    end
  end

  path "/api/v1/accumulators_report/{thing_name}" do
    get 'Retrieves all accumulators related with a specific things' do
      tags 'Alarms Report'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :thing_name, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: "date[start_date]", :in => :query, :type => :string
      parameter name: "date[end_date]", :in => :query, :type => :string

      response '200', 'accumulators founded' do
        let(:start_date)         { (Time.now - 2.days).to_time.to_i.to_s }
        let(:end_date)           { Time.now.to_time.to_i.to_s }
        let(:'date[start_date]') { start_date }
        let(:'date[end_date]')   { end_date }
        let(:location)           { create(:location) }
        let(:thing)              { create(:thing, units: { liter: 200 }, locates: location) }
        let(:uplink)             { create(:uplink, time: end_date, thing: thing) }
        let(:user)               { create(:user) }
        let!(:accumulator1)      { create(:accumulator, uplink: uplink) }
        let(:thing_name)         { thing.name }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          properties: {
            thing_id: { type: :string },
            thing_name: { type: :string },
            accumulators: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  date: { type: :string },
                  value: { type: :string },
                  consumption_delta: { type: :integer },
                  accumulated_delta: { type: :integer }
                }
              }
            },
            consumptions_by_month: {
              type: :object,
              properties: {
                value: { type: :string },
                days_count: { type: :integer },
                months: { type: :array }
              }
            },
            projected_consumption: {
              type: :object,
              properties: {
                days_count: {type: :integer},
                value: {type: :float}
              }
            },            
            required: ['thing_id', 'thing_name', 'accumulators', 'consumptions_by_month', 'projected_consumption']
          }

        run_test!
      end

      response '404', 'The thing thing_name does not exist' do
        let(:'date[start_date]') { (Time.now - 2.days).to_time.to_i.to_s }
        let(:'date[end_date]')   { Time.now.to_time.to_i.to_s }
        let(:user)               { create(:user) }
        let(:thing_name)         { 'invalid_name' }
        let(:Authorization)      { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          properties: {
            errors: { type: :string },
            code: { type: :integer }
          },
          required: [ 'errors', 'code' ]

        run_test!
      end
    end
  end
end
