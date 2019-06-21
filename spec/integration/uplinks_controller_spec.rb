require 'swagger_helper'

RSpec.describe "Uplinks API", :type => :request do
  path "/api/v1/uplinks" do
    get 'Retrieves all Uplinks' do
      tags 'Uplinks'
      produces 'application/json'

      response '200', 'last uplink found' do
        let(:user) { create(:user) }
        let!(:uplink) { create(:uplink) }
        let(:Authorization) { JsonWebToken.encode({ user_id: user.id }) }
        parameter({
         :in => :header,
         :type => :string,
         :name => :Authorization,
         :required => true,
         :description => 'Client token'
        })

        schema type: :object,
          required: [ 'id', 'data', 'avgsnr', 'rssi', 'long', 'lat', 'snr', 'station', 'seqnumber', 'time', 'sec_uplinks', 'sec_downlinks' ],
          items:
            {
              properties: {
                id: { type: :string },
                data: { type: :string },
                avgsnr: { type: :string },
                rssi: { type: :string },
                long: { type: :string },
                lat: { type: :string },
                snr: { type: :string },
                station: { type: :string },
                seqnumber: { type: :string },
                time: { type: :string },
                sec_uplinks: { type: :string },
                sec_downlinks: { type: :string }
              }
          }

        run_test!
      end

      response '404', 'no uplinks found' do
        let(:user) { create(:user) }
        let(:'Authorization') { JsonWebToken.encode({ user_id: user.id }) }
        run_test!
      end
    end
  end
end
