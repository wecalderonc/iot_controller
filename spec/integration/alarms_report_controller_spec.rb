require 'swagger_helper'
require 'rails_helper'

RSpec.describe "Alarms Report API", :type => :request do
  path "/api/v1/alarms_report" do
    get 'Retrieves all alarms related with all things' do
      tags 'Alarms Report'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: "date[start_date]", :in => :query, :type => :string
      parameter name: "date[end_date]", :in => :query, :type => :string

      response '200', 'alarms founded' do
        let(:start_date)         { (Time.now - 2.days).to_time.to_i.to_s }
        let(:end_date)           { (Time.now - 2.days).to_time.to_i.to_s }
        let(:'date[start_date]') { start_date }
        let(:'date[end_date]')   { end_date }
        let(:uplink)             { create(:uplink, time: end_date) }
        let(:user)               { create(:user) }
        let!(:alarm1)            { create(:alarm, uplink: uplink) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
        items: {
          type: :object,
          properties: {
            thing_id: { type: :string },
            thing_name: { type: :string },
            alarms: { 
              type: :array,
              items: {
                type: :object,
                properties: {
                  date: { type: :string },
                  value: { type: :string }
                }
              }
            }
          },
          required: ['thing_id', 'thing_name', 'alarms']
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
  path "/api/v1/alarms_report/{thing_name}" do
    get 'Retrieves all alarms related with a specific things' do
      tags 'Alarms Report'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :thing_name, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string
      parameter name: "date[start_date]", :in => :query, :type => :string
      parameter name: "date[end_date]", :in => :query, :type => :string

      response '200', 'alarms founded' do
        let(:start_date)         { (Time.now - 2.days).to_time.to_i.to_s }
        let(:end_date)           { (Time.now - 2.days).to_time.to_i.to_s }
        let(:'date[start_date]') { start_date }
        let(:'date[end_date]')   { end_date }
        let(:uplink)             { create(:uplink, time: end_date) }
        let(:user)               { create(:user) }
        let(:alarm1)             { create(:alarm, uplink: uplink) }
        let(:thing_name)         { alarm1.uplink.thing.name }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
        items: {
          type: :object,
          properties: {
            thing_id: { type: :string },
            thing_name: { type: :string },
            alarms: { 
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
          required: ['thing_id', 'thing_name', 'alarms']
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
