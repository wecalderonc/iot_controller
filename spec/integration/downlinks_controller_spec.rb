require 'swagger_helper'

RSpec.describe "Downlinks API", :type => :request do
  path "/api/v1/downlinks" do
    post 'Generates a downlink' do
      tags 'Downlinks'
      consumes 'application/json'
      produces 'application/json'

      parameter name: 'Authorization',  :in => :header, :type => :string

      parameter name: :input, in: :body, schema: {
        type: :object,
        properties: {
          action_type:   { :type => :string },
          payload:       { :type => :string },
          thing_name:    { :type => :string }
        },
        required: [ 'action_type', 'type', 'thing_name' ]
      }

      response '200', 'The thing does not exist' do
        schema type: :object,
          properties: {
            errors: { type: :string },
          },
          required: [ 'errors' ]

        let(:user)          { create(:user) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing)          { create(:thing, name: '2BEE81') }
        let(:uplink)         { create(:uplink, thing: thing) }
        let!(:accumulator)   { create(:accumulator, uplink: uplink) }
        let(:action_type)    { :instant_cut }
        let(:thing_name)     { "holi" }

        let(:input) {{
          action_type: action_type,
          thing_name: thing_name
        }}

        run_test!
      end

      response '200', 'The action is not in the list' do
        schema type: :object,
          properties: {
            errors: { type: :string },
          },
          required: [ 'errors' ]

        let(:user)          { create(:user) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing)          { create(:thing, name: '2BEE81') }
        let(:uplink)         { create(:uplink, thing: thing) }
        let!(:accumulator)   { create(:accumulator, uplink: uplink) }
        let(:action_type)    { :holi }
        let(:thing_name)     { Thing.last.name }

        let(:input) {{
          action_type: action_type,
          thing_name: thing_name
        }}

        run_test!
      end

      response '200', 'The value is not filled' do
        schema type: :object,
          properties: {
            errors: { type: :object },
          },
          required: [ 'errors' ]

        let(:user)          { create(:user) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing)          { create(:thing, name: '2BEE81') }
        let(:uplink)         { create(:uplink, thing: thing) }
        let!(:accumulator)   { create(:accumulator, uplink: uplink) }
        let(:action_type)    { :scheduled_cut }
        let(:thing_name)     { Thing.last.name }

        let(:input) {{
          action_type: action_type,
          thing_name: thing_name
        }}

        run_test!
      end

      response '200', 'Downlink generated with wrong payload' do
        schema type: :object,
          properties: {
            message: { type: :object },
          },
          required: [ 'errors' ]

        let(:user)          { create(:user) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing)          { create(:thing, name: '2BEE81') }
        let(:uplink)         { create(:uplink, thing: thing) }
        let!(:accumulator)   { create(:accumulator, uplink: uplink) }
        let(:action_type)    { :scheduled_cut }
        let(:value)          { "FFFFFF" }
        let(:thing_name)     { Thing.last.name }

        let(:input) {{
          action_type: action_type,
          value: value,
          thing_name: thing_name
        }}

        run_test!
      end

      response '200', 'Downlink generated with payload', vcr: { cassette_name: "shadows_update_scheduled_cut_success" } do
        schema type: :object,
          properties: {
            thing_name: { type: :string },
            action_type: { type: :string },
            payload: { type: :string },
            value: { type: :string },
          },
          required: [ 'payload', 'thing_name', 'action_type', 'value' ]

        let(:user)          { create(:user) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing)          { create(:thing, name: '2BEE81') }
        let(:uplink)         { create(:uplink, thing: thing) }
        let!(:accumulator)   { create(:accumulator, uplink: uplink) }
        let(:action_type)    { :scheduled_cut }
        let(:value)          { "0000" }
        let(:thing_name)     { Thing.last.name }
        let(:input_method)   { :consumption }

        let(:input) {{
          action_type: action_type,
          value: value,
          input_method: input_method,
          thing_name: thing_name
        }}

        run_test!
      end

      response '200', 'Downlink generated without payload', vcr: { cassette_name: "shadows_update_instant_cut_success" } do
        schema type: :object,
          properties: {
            thing_name: { type: :string },
            action_type: { type: :string },
            payload: { type: :string },
          },
          required: [ 'payload', 'thing_name', 'action_type' ]

        let(:user)          { create(:user) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing)          { create(:thing, name: '2BEE81') }
        let(:uplink)         { create(:uplink, thing: thing) }
        let!(:accumulator)   { create(:accumulator, uplink: uplink) }
        let(:action_type)    { :instant_cut }
        let(:thing_name)     { Thing.last.name }

        let(:input) {{
          action_type: action_type,
          thing_name: thing_name
        }}

        run_test!
      end

      response '401', 'Unauthorized' do
        let(:user) { create(:user) }
        let(:'Authorization') { "" }
        let(:input) { {} }

        run_test!
      end
    end
  end
end
