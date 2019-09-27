require 'swagger_helper'

RSpec.describe "Alarms API", :type => :request do
  path "/api/v1/things/{thing_name}/alarms/{id}" do
    put 'Retrieves a viewed alarm' do
      tags 'Alarms'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :thing_name, :in => :path, :type => :string
      parameter name: :id, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'alarms founded' do
        let(:user)       { create(:user) }
        let(:alarm)      { create(:alarm) }
        let(:thing)      { alarm.uplink.thing }
        let(:thing_name) { alarm.uplink.thing.name  }
        let(:id)         { alarm.id }
        let!(:owner)     { Owner.create(from_node: user, to_node: thing) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :object,
          required: ['created_at', 'updated_at', 'value', 'viewed_date', 'viewed', 'id'],
          properties: {
            created_at: { type: :string },
            updated_at: { type: :string },
            value:      { type: :string },
            viewed_date:{ type: :string },
            viewed:     { type: :boolean },
            id:         { type: :string }
          }

        run_test!

      end

      response '401', 'Token is missing' do
        let(:user)       { create(:user) }
        let(:thing)      { uplink.thing.name }
        let(:thing_name) { alarm.uplink.thing.name  }
        let(:uplink)     { create(:uplink) }
        let(:alarm)      { create(:alarm) }
        let(:id)         { alarm.id }

        let(:'Authorization') { "Access denied!" }

        run_test!
      end

      response '404', 'The alarm does not exist' do
        let(:user)          { create(:user) }
        let(:thing)         { uplink.thing }
        let(:thing_name)    { alarm.uplink.thing.name  }
        let(:uplink)        { create(:uplink) }
        let(:alarm)         { create(:alarm) }
        let!(:owner)        { Owner.create(from_node: user, to_node: thing) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:id) { "invalid_id" }

        run_test!
      end
    end
  end

  path "/api/v1/things/{thing_name}/alarms" do
    get 'Retrieves all alarms from a thing' do
      tags 'Alarms'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :thing_name, :in => :path, :type => :string
      parameter name: 'Authorization', :in => :header, :type => :string

      response '200', 'alarms founded' do
        let(:user)       { create(:user) }
        let(:alarm)      { create(:alarm) }
        let(:thing)      { alarm.uplink.thing }
        let(:thing_name) { alarm.uplink.thing.name }
        let(:uplink)     { create(:uplink, thing: thing) }
        let!(:alarm2)    { create(:alarm, uplink: uplink) }
        let!(:owner)     { Owner.create(from_node: user, to_node: thing) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        schema type: :array,
          required: ['created_at', 'updated_at', 'value', 'viewed_date', 'viewed', 'id'],
          properties: {
            id:         { type: :string },
            value:      { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            viewed:     { type: :boolean },
            viewed_date:{ type: :string }
          }

        run_test!
      end

      response '401', 'Token is missing' do
        let(:user)        { create(:user) }
        let(:thing)       { uplink.thing.name }
        let(:thing_name)  { alarm.uplink.thing.name  }
        let(:uplink)      { create(:uplink) }
        let(:alarm)       { create(:alarm) }

        let(:'Authorization') { "Access denied!" }

        run_test!
      end

      response '403', 'not authorized to access' do
        let(:user_no_relations) { create(:user) }
        let(:alarm)             { create(:alarm) }
        let(:Authorization)     { JsonWebToken.encode({ user_id: user_no_relations.id }) }

        let(:thing_name) { alarm.uplink.thing.name }

        run_test!
      end

      response '404', 'thing not found' do
        let(:user)    { create(:user) }
        let(:alarm)   { create(:alarm) }
        let(:thing)   { alarm.uplink.thing }
        let(:uplink)  { create(:uplink, thing: thing) }
        let!(:owner)  { Owner.create(from_node: user, to_node: thing) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing_name) { "wrong_name" }

        run_test!
      end

      response '404', 'alarms not found' do
        let(:user)    { create(:user) }
        let(:thing)   { uplink.thing }
        let(:uplink)  { create(:uplink) }
        let!(:owner)  { Owner.create(from_node: user, to_node: thing) }

        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }

        let(:thing_name) { uplink.thing.name }

        run_test!
      end
    end
  end
end
